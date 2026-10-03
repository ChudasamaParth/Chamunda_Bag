import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class ProductInfo extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onAddToCart;

  const ProductInfo({super.key, required this.product, this.onAddToCart});

  Color getColor(String color) {
    switch (color.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category
          Text(
            product.category,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          // Product name
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 6),

          // Rating
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                product.rating.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${product.reviewCount})',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
