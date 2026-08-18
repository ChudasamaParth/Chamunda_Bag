import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;

  final String? label;

  final bool obscureText;
  final Widget? suffixIcon;

  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  final TextInputAction? textInputAction;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.prefixIcon,

    this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 8),
        ],

        TextFormField(
          controller: controller,

          obscureText: obscureText,

          keyboardType: keyboardType,

          textInputAction: textInputAction,

          validator: validator,

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),

            prefixIcon: Icon(prefixIcon, color: AppColors.primary, size: 21),

            suffixIcon: suffixIcon,

            filled: true,

            fillColor: Colors.white,

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),

              borderSide: BorderSide(color: Colors.grey.shade200),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),

              borderSide: BorderSide(color: AppColors.primary, width: 1.4),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),

              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
