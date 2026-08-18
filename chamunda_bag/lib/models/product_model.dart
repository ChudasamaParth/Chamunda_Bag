import 'package:flutter/material.dart';

class ProductModel {
  final String id;

  // Basic
  final String name;
  final String category;
  final String brand;

  // Images
  final List<String> galleryImages;
  // Price
  final double price;
  final double oldPrice;
  final int discount;

  // Rating
  final double rating;
  final int reviewCount;

  // Description
  final String description;

  // FeaturesCA
  final List<String> features;

  // Specifications
  final String material;
  final String size;
  final double weight;
  final int compartments;

  // Available colors
  final List<String> colors;

  // Stock
  final bool inStock;
  final bool isBestSeller;
  final bool isNewArrival;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.brand,
    required this.galleryImages,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.features,
    required this.material,
    required this.size,
    required this.weight,
    required this.compartments,
    required this.colors,
    required this.inStock,
    required this.isBestSeller,
    required this.isNewArrival,
  });

  /// First image helper
  String get thumbnail => galleryImages.first;
}
