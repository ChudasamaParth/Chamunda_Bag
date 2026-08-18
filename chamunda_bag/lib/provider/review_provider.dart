import 'package:chamunda_bag/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews =>
      List.unmodifiable(_reviews);

  // --------------------------------------------------
  // GET REVIEWS
  // --------------------------------------------------

  Future<void> loadReviews(String productId) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .orderBy('createdAt', descending: true)
          .get();

      _reviews.clear();

      for (final document in snapshot.docs) {
        _reviews.add(
          ReviewModel.fromMap(
            document.id,
            document.data(),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    }
  }

  // --------------------------------------------------
  // ADD REVIEW
  // --------------------------------------------------

  Future<void> addReview({
    required String productId,
    required String userName,
    required double rating,
    required String comment,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      final reviewRef = _firestore
          .collection('products')
          .doc(productId)
          .collection('reviews')
          .doc();

      final review = ReviewModel(
        id: reviewRef.id,
        productId: productId,
        userId: user.uid,
        userName: userName,
        rating: rating,
        comment: comment,
        createdAt: DateTime.now(),
      );

      await reviewRef.set(
        review.toMap(),
      );

      _reviews.insert(0, review);

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding review: $e');
    }
  }

  // --------------------------------------------------
  // UPDATE REVIEW
  // --------------------------------------------------

  Future<void> updateReview({
    required ReviewModel review,
    required double rating,
    required String comment,
  }) async {
    try {
      await _firestore
          .collection('products')
          .doc(review.productId)
          .collection('reviews')
          .doc(review.id)
          .update({
        'rating': rating,
        'comment': comment,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final index = _reviews.indexWhere(
        (item) => item.id == review.id,
      );

      if (index != -1) {
        _reviews[index] = ReviewModel(
          id: review.id,
          productId: review.productId,
          userId: review.userId,
          userName: review.userName,
          rating: rating,
          comment: comment,
          createdAt: review.createdAt,
          updatedAt: DateTime.now(),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating review: $e');
    }
  }

  // --------------------------------------------------
  // DELETE REVIEW
  // --------------------------------------------------

  Future<void> deleteReview(
    ReviewModel review,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(review.productId)
          .collection('reviews')
          .doc(review.id)
          .delete();

      _reviews.removeWhere(
        (item) => item.id == review.id,
      );

      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting review: $e');
    }
  }

  // --------------------------------------------------
  // CHECK CURRENT USER REVIEW
  // --------------------------------------------------

  ReviewModel? get myReview {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      return _reviews.firstWhere(
        (review) => review.userId == user.uid,
      );
    } catch (_) {
      return null;
    }
  }

  // --------------------------------------------------
  // AVERAGE RATING
  // --------------------------------------------------

  double get averageRating {
    if (_reviews.isEmpty) {
      return 0;
    }

    final total = _reviews.fold<double>(
      0,
      (sum, review) => sum + review.rating,
    );

    return total / _reviews.length;
  }
}