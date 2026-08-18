import 'package:chamunda_bag/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _items = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<ProductModel> get items => _items;

  CollectionReference<Map<String, dynamic>>? get _wishlistRef {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return _firestore.collection('users').doc(user.uid).collection('wishlist');
  }

  // --------------------------------------------------
  // CHECK PRODUCT IN WISHLIST
  // --------------------------------------------------

  bool isInWishlist(ProductModel product) {
    return _items.any((item) => item.id == product.id);
  }

  // --------------------------------------------------
  // ADD / REMOVE WISHLIST
  // --------------------------------------------------

  Future<void> toggle(ProductModel product) async {
    final wishlistRef = _wishlistRef;

    // User not logged in
    if (wishlistRef == null) {
      return;
    }

    if (isInWishlist(product)) {
      // Remove from local list
      _items.removeWhere((item) => item.id == product.id);

      notifyListeners();

      // Remove from Firestore
      await wishlistRef.doc(product.id).delete();
    } else {
      // Add to local list
      _items.add(product);

      notifyListeners();

      // Store ONLY required wishlist information
      await wishlistRef.doc(product.id).set({
        'productId': product.id,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  // --------------------------------------------------
  // REMOVE PRODUCT
  // --------------------------------------------------

  Future<void> remove(ProductModel product) async {
    final wishlistRef = _wishlistRef;

    if (wishlistRef == null) {
      return;
    }

    _items.removeWhere((item) => item.id == product.id);

    notifyListeners();

    await wishlistRef.doc(product.id).delete();
  }

  // --------------------------------------------------
  // LOAD WISHLIST
  // --------------------------------------------------

  Future<void> loadWishlist(List<ProductModel> allProducts) async {
    final wishlistRef = _wishlistRef;

    if (wishlistRef == null) {
      return;
    }

    try {
      final snapshot = await wishlistRef.get();

      _items.clear();

      for (final document in snapshot.docs) {
        final productId = document.data()['productId'];

        final product = allProducts.cast<ProductModel?>().firstWhere(
          (product) => product?.id == productId,
          orElse: () => null,
        );

        if (product != null) {
          _items.add(product);
        }
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading wishlist: $e');
    }
  }

  // --------------------------------------------------
  // CLEAR WISHLIST
  // --------------------------------------------------

  Future<void> clearWishlist() async {
    final wishlistRef = _wishlistRef;

    if (wishlistRef == null) {
      return;
    }

    try {
      final snapshot = await wishlistRef.get();

      for (final document in snapshot.docs) {
        await document.reference.delete();
      }

      _items.clear();

      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing wishlist: $e');
    }
  }
}
