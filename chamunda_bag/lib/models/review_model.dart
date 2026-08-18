import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ReviewModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.updatedAt,
  });

  factory ReviewModel.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return ReviewModel(
      id: id,
      productId: data['productId'] ?? '',
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'User',
      rating: (data['rating'] ?? 0).toDouble(),
      comment: data['comment'] ?? '',
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(),
      updatedAt:
          (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null
          ? null
          : Timestamp.fromDate(updatedAt!),
    };
  }
}