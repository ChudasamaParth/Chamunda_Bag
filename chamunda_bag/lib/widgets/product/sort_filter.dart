import 'package:flutter/material.dart';

import '../../core/app_colors.dart';

class SortFilterBar extends StatelessWidget {
  final VoidCallback onSortTap;
  final VoidCallback onFilterTap;

  const SortFilterBar({
    super.key,
    required this.onSortTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip(
            icon: Icons.swap_vert_rounded,
            label: "Sort",
            onTap: onSortTap,
          ),

          const SizedBox(width: 12),

          _buildChip(
            icon: Icons.tune_rounded,
            label: "Filter",
            onTap: onFilterTap,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
