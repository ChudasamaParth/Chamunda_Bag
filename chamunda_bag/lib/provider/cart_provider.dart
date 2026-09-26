import 'package:chamunda_bag/models/cart_item_model.dart';
import 'package:chamunda_bag/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CartItemModel> get items => List.unmodifiable(_items);

  // --------------------------------------------------
  // CART TOTALS
  // --------------------------------------------------

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subtotal {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get originalTotal {
    return _items.fold(0, (sum, item) => sum + item.totalOldPrice);
  }

  double get savings {
    return originalTotal - subtotal;
  }

  double get shipping => 0;

  double get total => subtotal + shipping;

  // --------------------------------------------------
  // FIRESTORE CART REFERENCE
  // --------------------------------------------------

  CollectionReference<Map<String, dynamic>>? get _cartRef {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return _firestore.collection('users').doc(user.uid).collection('cart');
  }

  // --------------------------------------------------
  // CHECK PRODUCT IN CART
  // --------------------------------------------------

  bool isInCart(ProductModel product) {
    return _items.any((item) => item.product.id == product.id);
  }

  // --------------------------------------------------
  // ADD TO CART
  // --------------------------------------------------

  Future<bool> addToCart(ProductModel product) async {
    final cartRef = _cartRef;

    // User must be logged in.
    if (cartRef == null) {
      debugPrint('ADD TO CART: User is not logged in.');
      return false;
    }

    try {
      final index = _items.indexWhere((item) => item.product.id == product.id);

      // ------------------------------------------
      // PRODUCT ALREADY EXISTS
      // ------------------------------------------

      if (index != -1) {
        _items[index].quantity++;

        await cartRef.doc(product.id).update({
          'quantity': _items[index].quantity,
        });
      }
      // ------------------------------------------
      // NEW PRODUCT
      // ------------------------------------------
      else {
        final cartItem = CartItemModel(product: product);

        _items.add(cartItem);

        await cartRef.doc(product.id).set({
          'productId': product.id,
          'quantity': cartItem.quantity,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }

      notifyListeners();

      debugPrint('ADD TO CART SUCCESS: ${product.name}');

      return true;
    } catch (e) {
      debugPrint('ADD TO CART ERROR: $e');

      return false;
    }
  }

  // --------------------------------------------------
  // REMOVE FROM CART
  // --------------------------------------------------

  Future<bool> removeFromCart(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return false;
    }

    try {
      _items.removeWhere((item) => item.product.id == product.id);

      await cartRef.doc(product.id).delete();

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('REMOVE FROM CART ERROR: $e');

      return false;
    }
  }

  // --------------------------------------------------
  // INCREASE QUANTITY
  // --------------------------------------------------

  Future<bool> increaseQuantity(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return false;
    }

    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      return false;
    }

    try {
      _items[index].quantity++;

      await cartRef.doc(product.id).update({
        'quantity': _items[index].quantity,
      });

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('INCREASE QUANTITY ERROR: $e');

      return false;
    }
  }

  // --------------------------------------------------
  // DECREASE QUANTITY
  // --------------------------------------------------

  Future<bool> decreaseQuantity(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return false;
    }

    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      return false;
    }

    try {
      // ------------------------------------------
      // QUANTITY > 1
      // ------------------------------------------

      if (_items[index].quantity > 1) {
        _items[index].quantity--;

        await cartRef.doc(product.id).update({
          'quantity': _items[index].quantity,
        });
      }
      // ------------------------------------------
      // QUANTITY == 1
      // REMOVE PRODUCT
      // ------------------------------------------
      else {
        _items.removeAt(index);

        await cartRef.doc(product.id).delete();
      }

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('DECREASE QUANTITY ERROR: $e');

      return false;
    }
  }

  // --------------------------------------------------
  // CLEAR CART
  // --------------------------------------------------

  Future<bool> clearCart() async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return false;
    }

    try {
      final snapshot = await cartRef.get();

      for (final document in snapshot.docs) {
        await document.reference.delete();
      }

      _items.clear();

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('CLEAR CART ERROR: $e');

      return false;
    }
  }

  // --------------------------------------------------
  // LOAD CART
  // --------------------------------------------------

  Future<void> loadCart(List<ProductModel> allProducts) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      _items.clear();
      notifyListeners();
      return;
    }

    try {
      final snapshot = await cartRef.get();

      _items.clear();

      for (final document in snapshot.docs) {
        final data = document.data();

        final productId = data['productId'];
        final quantity = data['quantity'] ?? 1;

        ProductModel? product;

        for (final item in allProducts) {
          if (item.id == productId) {
            product = item;
            break;
          }
        }

        if (product != null) {
          final cartItem = CartItemModel(product: product);

          cartItem.quantity = quantity;

          _items.add(cartItem);
        }
      }

      // Newest/Firestore cart order isn't important here,
      // but this keeps the local list consistent.

      notifyListeners();

      debugPrint('CART LOADED: ${_items.length} products');
    } catch (e) {
      debugPrint('LOAD CART ERROR: $e');
    }
  }
}
