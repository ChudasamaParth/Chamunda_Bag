import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class ActiveFilterChips extends StatelessWidget {
  final double selectedPrice;
  final double selectedRating;
  final int selectedDiscount;

  final VoidCallback onRemovePrice;
  final VoidCallback onRemoveRating;
  final VoidCallback onRemoveDiscount;

  const ActiveFilterChips({
    super.key,
    required this.selectedPrice,
    required this.selectedRating,
    required this.selectedDiscount,
    required this.onRemovePrice,
    required this.onRemoveRating,
    required this.onRemoveDiscount,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];

    if (selectedPrice < 5000) {
      chips.add(_chip("₹ Under ₹${selectedPrice.toInt()}", onRemovePrice));
    }

    if (selectedRating > 0) {
      chips.add(_chip("⭐ ${selectedRating.toInt()}★+", onRemoveRating));
    }

    if (selectedDiscount > 0) {
      chips.add(_chip("$selectedDiscount% OFF", onRemoveDiscount));
    }

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => chips[index],
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: chips.length,
      ),
    );
  }

  Widget _chip(String text, VoidCallback onTap) {
    return Chip(
      backgroundColor: AppColors.primary.withOpacity(.1),
      label: Text(text),
      deleteIcon: const Icon(Icons.close, size: 18),
      deleteIconColor: AppColors.primary,
      onDeleted: onTap,
    );
  }
}
