import 'package:chamunda_bag/screens/product/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class WishlistCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const WishlistCard({
    super.key,
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ProductDetailScreen(product: product);
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: product.id,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: AspectRatio(
                      aspectRatio: 1.25,
                      child: Image.asset(
                        product.galleryImages.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onRemove,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        "${product.rating}",
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(width: 6),

                      Text(
                        "(${product.reviewCount})",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Text(
                        "₹${product.price.toInt()}",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        "₹${product.oldPrice.toInt()}",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "${product.discount}% OFF",
                          style: GoogleFonts.poppins(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text("Add to Cart"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
