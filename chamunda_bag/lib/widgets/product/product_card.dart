import 'package:chamunda_bag/screens/product/product_detail_screen.dart';
import 'package:chamunda_bag/widgets/heart_icon.dart';
import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            //==========================
            // IMAGE SECTION
            //==========================
            SizedBox(
              height: 165,
              child: Stack(
                children: [
                  /// Background
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Color(0xffF8F6F3)),
                  ),

                  /// Product Image
                  Center(
                    child: Hero(
                      tag: "${product.id}-0",
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Image.asset(
                          product.thumbnail,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  /// Favourite
                  Positioned(
                    top: 12,
                    left: 12,
                    child: WishlistButton(product: product),
                  ),

                  /// Discount
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "-${product.discount}%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Footer will come next
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Category
                    Row(
                      children: [
                        Text(
                          product.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        /// Rating
                        Container(
                          margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 16,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                "${product.rating}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    /// Product Name
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Bottom Row
                    Row(
                      children: [
                        /// Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${product.price.toInt()}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              "₹${product.oldPrice.toInt()}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        /// Add Button
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
