import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 85,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Colors.white
                    : AppColors.primary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}