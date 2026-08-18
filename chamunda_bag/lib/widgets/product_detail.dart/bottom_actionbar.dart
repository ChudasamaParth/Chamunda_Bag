import 'package:chamunda_bag/provider/cart_provider.dart';
import 'package:chamunda_bag/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class BottomActionBar extends StatelessWidget {
  final ProductModel product;

  const BottomActionBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final isInCart = cart.isInCart(product);

        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                /// Price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Total Price",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "₹${product.price.toInt()}",
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Button
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (!isInCart) {
                          cart?.addToCart(product);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${product.name} added to cart"),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CartScreen(),
                            ),
                          );
                        }
                      },

                      icon: Icon(
                        isInCart
                            ? Icons.check_circle
                            : Icons.shopping_bag_outlined,
                      ),

                      label: Text(
                        isInCart ? "Go to Cart" : "Add to Cart",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart
                            ? Colors.green
                            : AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
