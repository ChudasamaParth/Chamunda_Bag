import 'package:chamunda_bag/data/product_data/product_data.dart';
import 'package:chamunda_bag/screens/product/product_screen.dart';
import 'package:chamunda_bag/widgets/product/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

import '../../models/product_model.dart';

class FeaturedProductsSection extends StatelessWidget {
  const FeaturedProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> featuredProducts = allProducts
        .where((e) => e.isBestSeller)
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Featured Products",
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductsScreen(
                      title: "Featured Products",
                      products: featuredProducts,
                    ),
                  ),
                );
              },
              child: Text(
                "See All",
                style: GoogleFonts.poppins(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: featuredProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 18,
            childAspectRatio: 0.48,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: featuredProducts[index]);
          },
        ),
      ],
    );
  }
}
