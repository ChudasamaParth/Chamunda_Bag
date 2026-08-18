import 'dart:async';

import 'package:chamunda_bag/core/app_colors.dart';
import 'package:chamunda_bag/data/home_screen_data.dart';
import 'package:chamunda_bag/data/product_data/category_model.dart';

import 'package:chamunda_bag/screens/home/featured_products.dart';
import 'package:chamunda_bag/screens/product/product_screen.dart';
import 'package:chamunda_bag/widgets/banner_slider.dart';
import 'package:chamunda_bag/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        shadowColor: Colors.white70,
        title: Image.asset(
          "assets/images/brand_icon.png",
          height: 60,
          width: 60,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeBannerSlider(),

              const SizedBox(height: 30),

              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      title: categories[index]["title"],
                      icon: categories[index]["icon"],
                      isSelected: selectedCategory == index,
                      onTap: () {
                        final categoryName =
                            categories[index]["title"] as String;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductsScreen(
                              title: "$categoryName Bags",
                              products: categoryProducts[categoryName] ?? [],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              const FeaturedProductsSection(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
