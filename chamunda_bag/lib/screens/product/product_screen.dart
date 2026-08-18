import 'package:chamunda_bag/widgets/product/active_filter_chips.dart';
import 'package:chamunda_bag/widgets/product/filter_bottom_list.dart';
import 'package:chamunda_bag/widgets/product/short_bottom_list.dart';
import 'package:chamunda_bag/widgets/product/sort_filter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';
import '../../models/product_model.dart';
import '../../widgets/product/product_card.dart';

class ProductsScreen extends StatefulWidget {
  final String title;
  final List<ProductModel> products;
  const ProductsScreen({
    super.key,
    required this.title,
    required this.products,
  });

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool isSearching = false;
  double selectedPrice = 5000;
  double selectedRating = 0;
  int selectedDiscount = 0;

  late List<ProductModel> displayedProducts;

  final TextEditingController searchController = TextEditingController();
  String selectedSort = "Popular";

  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(widget.products);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void sortProducts(String sortBy) {
    setState(() {
      selectedSort = sortBy;

      switch (sortBy) {
        case "Popular":
          break;

        case "Price: Low to High":
          displayedProducts.sort((a, b) => a.price.compareTo(b.price));
          break;

        case "Price: High to Low":
          displayedProducts.sort((a, b) => b.price.compareTo(a.price));
          break;

        case "Highest Rated":
          displayedProducts.sort((a, b) => b.rating.compareTo(a.rating));
          break;

        case "Biggest Discount":
          displayedProducts.sort((a, b) => b.discount.compareTo(a.discount));
          break;
      }
    });
  }

  void applyFilters(double price, double rating, int discount) {
    setState(() {
      selectedPrice = price;
      selectedRating = rating;
      selectedDiscount = discount;

      displayedProducts = widget.products.where((product) {
        final priceMatch = product.price <= selectedPrice;

        final ratingMatch =
            selectedRating == 0 || product.rating >= selectedRating;

        final discountMatch =
            selectedDiscount == 0 || product.discount >= selectedDiscount;

        return priceMatch && ratingMatch && discountMatch;
      }).toList();

      // Keep the selected sorting after filtering
      sortProducts(selectedSort);
    });
  }

  void showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return SortBottomSheet(
          selectedSort: selectedSort,
          onSelected: sortProducts,
        );
      },
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return FilterBottomSheet(
          selectedPrice: selectedPrice,
          selectedRating: selectedRating,
          selectedDiscount: selectedDiscount,
          onApply: applyFilters,
        );
      },
    );
  }

  void removePriceFilter() {
    applyFilters(5000, selectedRating, selectedDiscount);
  }

  void removeRatingFilter() {
    applyFilters(selectedPrice, 0, selectedDiscount);
  }

  void removeDiscountFilter() {
    applyFilters(selectedPrice, selectedRating, 0);
  }

  void searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedProducts = List.from(widget.products);
      } else {
        displayedProducts = widget.products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),

        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                onChanged: searchProducts,
                decoration: InputDecoration(
                  hintText: "Search ${widget.title.toLowerCase()}...",
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.poppins(),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    "${displayedProducts.length} Products",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),

        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  searchController.clear();
                  displayedProducts = List.from(widget.products);
                }

                isSearching = !isSearching;
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 12),

          SortFilterBar(
            onSortTap: showSortBottomSheet,
            onFilterTap: () {
              showFilterBottomSheet();
            },
          ),

          const SizedBox(height: 12),

          ActiveFilterChips(
            selectedPrice: selectedPrice,
            selectedRating: selectedRating,
            selectedDiscount: selectedDiscount,

            onRemovePrice: removePriceFilter,
            onRemoveRating: removeRatingFilter,
            onRemoveDiscount: removeDiscountFilter,
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                itemCount: displayedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 18,
                  childAspectRatio: 0.50,
                ),
                itemBuilder: (context, index) {
                  return ProductCard(product: displayedProducts[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
