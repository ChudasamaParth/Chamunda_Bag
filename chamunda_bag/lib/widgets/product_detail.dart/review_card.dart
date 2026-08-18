import 'package:chamunda_bag/models/review_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;
  final bool isMyReview;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    this.isMyReview = false,
    this.onEdit,
    this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return "Just now";
      }

      return "${difference.inHours}h ago";
    }

    if (difference.inDays == 1) {
      return "Yesterday";
    }

    if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    }

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User information
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: AppColors.primary.withValues(alpha: .1),
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : "U",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      _formatDate(review.createdAt),
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),

                  const SizedBox(width: 3),

                  Text(
                    review.rating.toStringAsFixed(1),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Comment
          Text(
            review.comment,
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),

          // Edit / Delete
          if (isMyReview) ...[
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text("Edit"),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),

                TextButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 17),
                  label: const Text("Delete"),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
