import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Category
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              product.category.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                letterSpacing: .5,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Product Name
          Text(
            product.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.25,
            ),
          ),

          const SizedBox(height: 16),

          /// Rating & Reviews
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 22),

              const SizedBox(width: 6),

              Text(
                product.rating.toString(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(width: 6),

              Text(
                "(${product.reviewCount} Reviews)",
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "₹${product.price.toInt()}",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                "₹${product.oldPrice.toInt()}",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  "${product.discount}% OFF",
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Divider(color: Colors.grey.shade300, height: 32),
        ],
      ),
    );
  }
}
