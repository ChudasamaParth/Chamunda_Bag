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

  /// Total number of products (including quantity)
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Cart subtotal
  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  /// Original price before discount
  double get originalTotal =>
      _items.fold(0, (sum, item) => sum + item.totalOldPrice);

  /// Total savings
  double get savings => originalTotal - subtotal;

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

  Future<void> addToCart(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity++;

      await cartRef.doc(product.id).update({
        'quantity': _items[index].quantity,
      });
    } else {
      _items.add(CartItemModel(product: product));

      await cartRef.doc(product.id).set({
        'productId': product.id,
        'quantity': 1,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }

    notifyListeners();
  }

  // --------------------------------------------------
  // REMOVE FROM CART
  // --------------------------------------------------

  Future<void> removeFromCart(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return;
    }

    _items.removeWhere((item) => item.product.id == product.id);

    await cartRef.doc(product.id).delete();

    notifyListeners();
  }

  // --------------------------------------------------
  // INCREASE QUANTITY
  // --------------------------------------------------

  Future<void> increaseQuantity(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity++;

      await cartRef.doc(product.id).update({
        'quantity': _items[index].quantity,
      });

      notifyListeners();
    }
  }

  // --------------------------------------------------
  // DECREASE QUANTITY
  // --------------------------------------------------

  Future<void> decreaseQuantity(ProductModel product) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return;
    }

    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      return;
    }

    if (_items[index].quantity > 1) {
      _items[index].quantity--;

      await cartRef.doc(product.id).update({
        'quantity': _items[index].quantity,
      });
    } else {
      _items.removeAt(index);

      await cartRef.doc(product.id).delete();
    }

    notifyListeners();
  }

  // --------------------------------------------------
  // CLEAR CART
  // --------------------------------------------------

  Future<void> clearCart() async {
    final cartRef = _cartRef;

    if (cartRef == null) {
      return;
    }

    final snapshot = await cartRef.get();

    for (final document in snapshot.docs) {
      await document.reference.delete();
    }

    _items.clear();

    notifyListeners();
  }

  // --------------------------------------------------
  // LOAD CART
  // --------------------------------------------------

  Future<void> loadCart(List<ProductModel> allProducts) async {
    final cartRef = _cartRef;

    if (cartRef == null) {
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

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }
}
