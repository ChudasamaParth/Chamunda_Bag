import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class ProductFeatureChips extends StatelessWidget {
  final ProductModel product;

  const ProductFeatureChips({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _featureChip(
            icon: Icons.workspace_premium_rounded,
            label: "Best Seller",
          ),

          _featureChip(
            icon: Icons.water_drop_outlined,
            label: "Water Resistant",
          ),

          _featureChip(
            icon: Icons.verified_user_outlined,
            label: "1 Year Warranty",
          ),

          _featureChip(
            icon: Icons.local_shipping_outlined,
            label: "Free Delivery",
          ),
          Divider(color: Colors.grey.shade300, height: 32),
        ],
      ),
    );
  }

  Widget _featureChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),

          const SizedBox(width: 8),

          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
