import 'package:chamunda_bag/core/app_colors.dart';
import 'package:chamunda_bag/models/product_model.dart';

import 'package:chamunda_bag/provider/review_provider.dart';
import 'package:chamunda_bag/widgets/product_detail.dart/bottom_actionbar.dart';

import 'package:chamunda_bag/widgets/product_detail.dart/product_descreption.dart';
import 'package:chamunda_bag/widgets/product_detail.dart/product_feature_chip.dart';
import 'package:chamunda_bag/widgets/product_detail.dart/product_image_section.dart';
import 'package:chamunda_bag/widgets/product_detail.dart/product_info.dart';


import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController _pageController;
  int quantity = 0;

  int currentImage = 0;
  int selectedColor = 0;
  bool _reviewsLoaded = false;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(viewportFraction: .88);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_reviewsLoaded) {
      _reviewsLoaded = true;

      context.read<ReviewProvider>().loadReviews(widget.product.id);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      bottomNavigationBar: SafeArea(
        top: false,
        child: BottomActionBar(product: widget.product),
      ),

      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ProductImageSection(
                product: widget.product,
                pageController: _pageController,
                currentImage: currentImage,
                onImageChanged: (index) {
                  setState(() {
                    currentImage = index;
                    selectedColor = index;
                  });
                },
              ),

              ProductInfoSection(product: widget.product),

              ProductFeatureChips(product: widget.product),

              ProductDescreption(product: widget.product),

              const SizedBox(height: 28),

              // ReviewSection(
              //   onWriteReview: _openReviewForm,
              //   onEditReview: (review) {
              //     _openEditReviewSheet(review);
              //   },
              //   onDeleteReview: (review) {
              //     _deleteReview(review);
              //   },
              // ),

              // Space for BottomActionBar
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
