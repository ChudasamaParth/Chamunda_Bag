import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/product_model.dart';

class ProductImageSection extends StatefulWidget {
  final ProductModel product;
  final PageController pageController;
  final int currentImage;
  final ValueChanged<int> onImageChanged;

  const ProductImageSection({
    super.key,
    required this.product,
    required this.pageController,
    required this.currentImage,
    required this.onImageChanged,
  });

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  bool isFavorite = false;

  double currentPage = 0;

  @override
  void initState() {
    super.initState();

    widget.pageController.addListener(() {
      if (!mounted) return;

      final page = widget.pageController.page ?? 0;

      if (page != currentPage) {
        setState(() {
          currentPage = page;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xffFDFBF8), Color(0xffF4F1EC)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
      ),
      child: Stack(
        children: [
          /// PRODUCT IMAGES
          PageView.builder(
            controller: widget.pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.product.galleryImages.length,
            onPageChanged: widget.onImageChanged,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: widget.pageController,
                builder: (context, child) {
                  final difference = currentPage - index;

                  final scale = (1 - difference.abs() * .18).clamp(.82, 1.0);

                  final translate = difference * 70;

                  final lift = -(difference.abs() * 25);

                  final opacity = (1 - difference.abs() * .35).clamp(.4, 1.0);

                  return Opacity(
                    opacity: opacity,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, .0015)
                        ..translate(translate, lift)
                        ..rotateY(difference * -.28)
                        ..rotateZ(difference * .02)
                        ..scale(scale),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          /// Floating Shadow

                          /// Product Image
                          Hero(
                            tag: '${widget.product.id}-$index',
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 28,
                              ),
                              child: Image.asset(
                                widget.product.galleryImages[index],
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),

          /// Back Button
          Positioned(
            top: 20,
            left: 20,
            child: _circleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
          ),

          /// Favourite Button
          Positioned(
            top: 20,
            right: 20,
            child: _circleButton(
              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : AppColors.textPrimary,
              onTap: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
            ),
          ),
          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.product.galleryImages.length, (
                index,
              ) {
                final selected = index == widget.currentImage;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: selected ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
          ),

          /// Indicator
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary,
  }) {
    return Material(
      color: Colors.white,
      elevation: 5,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
