import 'package:chamunda_bag/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Dismissible(
      key: ValueKey(item.product.id),

      direction: DismissDirection.endToStart,

      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 30),
      ),

      onDismissed: (_) {
        cart.removeFromCart(item.product);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${item.product.name} removed"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },

      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Row(
          children: [
            /// IMAGE
            Hero(
              tag: item.product.id,
              child: Container(
                width: 95,
                height: 95,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F6F3),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Image.asset(
                  item.product.galleryImages.first,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.product.brand,
                    style: GoogleFonts.poppins(color: Colors.grey),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        "₹${item.product.price.toInt()}",
                        style: GoogleFonts.poppins(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffF6F6F6),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                cart.decreaseQuantity(item.product);
                              },
                            ),

                            Text(
                              item.quantity.toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cart.increaseQuantity(item.product);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
