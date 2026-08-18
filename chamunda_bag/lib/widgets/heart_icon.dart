import 'package:chamunda_bag/provider/wishlist_provider..dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product_model.dart';

class WishlistButton extends StatelessWidget {
  final ProductModel product;

  const WishlistButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, child) {
        final isFav = wishlist.isInWishlist(product);

        return Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 3,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              wishlist.toggle(product);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey(isFav),
                  color: isFav ? Colors.red : Colors.grey.shade700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
