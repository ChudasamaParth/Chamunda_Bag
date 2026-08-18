import 'package:chamunda_bag/provider/cart_provider.dart';
import 'package:chamunda_bag/screens/check_out/check_out_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          _row("Subtotal", "₹${cart.subtotal.toStringAsFixed(0)}"),

          const SizedBox(height: 12),

          _row(
            "Savings",
            "-₹${cart.savings.toStringAsFixed(0)}",
            color: Colors.green,
          ),

          const SizedBox(height: 12),

          _row("Shipping", "FREE", color: Colors.green),

          const Divider(height: 30),

          _row("Total", "₹${cart.total.toStringAsFixed(0)}", isBold: true),

          const SizedBox(height: 22),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CheckoutScreen();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                "Proceed to Checkout",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String title, String value, {Color? color, bool isBold = false}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey.shade700),
        ),

        const Spacer(),

        Text(
          value,
          style: GoogleFonts.poppins(
            color: color ?? Colors.black,
            fontSize: isBold ? 20 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
