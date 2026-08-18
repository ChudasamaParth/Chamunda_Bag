import 'package:chamunda_bag/provider/wishlist_provider..dart';
import 'package:chamunda_bag/screens/main_screen.dart';
import 'package:chamunda_bag/widgets/empty_whishlist_screen.dart';
import 'package:chamunda_bag/widgets/whishlist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MainScreen();
                },
              ),
            );
          },
        ),
        title: const Text(
          "Wishlist",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: wishlist.items.isEmpty
          ? const EmptyWishlist()
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: wishlist.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),
              itemBuilder: (context, index) {
                final product = wishlist.items[index];

                return WishlistCard(
                  product: product,

                  onTap: () {
                    // Navigate to Product Detail
                  },

                  onRemove: () {
                    wishlist.remove(product);
                  },

                  onAddToCart: () {
                    // We'll connect CartProvider later
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${product.name} added to cart")),
                    );
                  },
                );
              },
            ),
    );
  }
}
