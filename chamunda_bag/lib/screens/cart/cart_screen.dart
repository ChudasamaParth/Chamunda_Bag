import 'package:chamunda_bag/screens/cart/cart_item_card.dart';
import 'package:chamunda_bag/provider/cart_provider.dart';
import 'package:chamunda_bag/screens/cart/empty_card.dart';
import 'package:chamunda_bag/screens/cart/order_summary.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "My Cart",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: cart.items.isEmpty
              ? const EmptyCart()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 18),
                        itemBuilder: (_, index) {
                          return CartItemCard(item: cart.items[index]);
                        },
                      ),
                    ),

                    const OrderSummary(),
                  ],
                ),
        );
      },
    );
  }
}
