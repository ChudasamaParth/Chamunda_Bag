import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

class SortBottomSheet extends StatelessWidget {
  final String selectedSort;
  final ValueChanged<String> onSelected;

  const SortBottomSheet({
    super.key,
    required this.selectedSort,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      "Popular",
      "Price: Low to High",
      "Price: High to Low",
      "Highest Rated",
      "Biggest Discount",
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Drag Handle
          Container(
            height: 5,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 18),

          Text(
            "Sort Products",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          ...sortOptions.map(
            (option) => InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                onSelected(option);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 15,
                ),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: selectedSort == option
                      ? AppColors.primary.withOpacity(.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    if (selectedSort == option)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}