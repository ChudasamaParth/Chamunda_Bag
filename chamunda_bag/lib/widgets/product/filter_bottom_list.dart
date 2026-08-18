import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final double selectedPrice;
  final double selectedRating;
  final int selectedDiscount;

  final Function(double price, double rating, int discount) onApply;

  const FilterBottomSheet({
    super.key,
    required this.selectedPrice,
    required this.selectedRating,
    required this.selectedDiscount,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late double price;
  late double rating;
  late int discount;

  @override
  void initState() {
    super.initState();

    price = widget.selectedPrice;
    rating = widget.selectedRating;
    discount = widget.selectedDiscount;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Drag Handle
              Center(
                child: Container(
                  height: 5,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Filter Products",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              //-------------------------------------------------
              // PRICE
              //-------------------------------------------------
              Text(
                "Maximum Price",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),

              Slider(
                value: price,
                min: 500,
                max: 5000,
                divisions: 9,
                activeColor: AppColors.primary,
                label: "₹${price.toInt()}",
                onChanged: (value) {
                  setState(() {
                    price = value;
                  });
                },
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "₹${price.toInt()}",
                  style: GoogleFonts.poppins(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              //-------------------------------------------------
              // RATING
              //-------------------------------------------------
              Text(
                "Minimum Rating",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                children: [5, 4, 3].map((star) {
                  final selected = rating == star.toDouble();

                  return ChoiceChip(
                    label: Text("$star ★"),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() {
                        rating = star.toDouble();
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 28),

              //-------------------------------------------------
              // DISCOUNT
              //-------------------------------------------------
              Text(
                "Minimum Discount",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                children: [10, 20, 30, 40].map((value) {
                  final selected = discount == value;

                  return ChoiceChip(
                    label: Text("$value%"),
                    selected: selected,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                    ),
                    onSelected: (_) {
                      setState(() {
                        discount = value;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              //-------------------------------------------------
              // BUTTONS
              //-------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          252,
                          252,
                          252,
                        ),
                        foregroundColor: const Color.fromARGB(255, 100, 23, 23),
                      ),
                      onPressed: () {
                        setState(() {
                          price = 5000;
                          rating = 0;
                          discount = 0;
                        });
                      },
                      child: const Text("Reset"),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        widget.onApply(price, rating, discount);

                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Apply",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
