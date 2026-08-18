import '../../models/product_model.dart';

final List<ProductModel> officeBags = [
  ProductModel(
    id: "OB001",
    name: "Premium Leather Office Bag",
    category: "Office",
    brand: "Chamunda",

    galleryImages: [
      "assets/images/products/office_bag1.png",
      "assets/images/products/office_bag2.png",
      "assets/images/products/office_bag3.png",
    ],

    price: 2499,
    oldPrice: 3299,
    discount: 24,

    rating: 4.9,
    reviewCount: 286,

    description:
        "Elegant genuine leather office bag with a dedicated laptop compartment and premium finish. Perfect for professionals and executives.",

    features: [
      "15.6\" Laptop Sleeve",
      "Genuine Leather",
      "Water Resistant",
      "1 Year Warranty",
    ],

    material: "Genuine Leather",
    size: "42 × 31 × 12 cm",
    weight: 1.25,
    compartments: 4,

    colors: ["#000000", "#5D4037", "#3E2723"],

    inStock: true,
    isBestSeller: true,
    isNewArrival: false,
  ),

  ProductModel(
    id: "OB002",
    name: "Executive Messenger Bag",
    category: "Office",
    brand: "Chamunda",

    galleryImages: [
      "assets/images/products/office_bag2.png",
      "assets/images/products/office_bag2.png",
      "assets/images/products/office_bag3.png",
    ],

    price: 1899,
    oldPrice: 2499,
    discount: 24,

    rating: 4.7,
    reviewCount: 174,

    description:
        "Professional messenger bag featuring padded laptop storage, multiple organizer pockets, and an adjustable shoulder strap.",

    features: [
      "Laptop Compartment",
      "Organizer Pocket",
      "Adjustable Strap",
      "Premium Zippers",
    ],

    material: "PU Leather",
    size: "40 × 30 × 10 cm",
    weight: 1.05,
    compartments: 5,

    colors: ["#212121", "#6D4C41", "#37474F"],

    inStock: true,
    isBestSeller: false,
    isNewArrival: true,
  ),

  ProductModel(
    id: "OB003",
    name: "Classic Office Briefcase",
    category: "Office",
    brand: "Chamunda",

    galleryImages: [
      "assets/images/products/office_bag3.png",
      "assets/images/products/office_bag2.png",
      "assets/images/products/office_bag3.png",
    ],

    price: 2199,
    oldPrice: 2899,
    discount: 24,

    rating: 4.8,
    reviewCount: 203,

    description:
        "A classic business briefcase with spacious storage, reinforced handles, and premium craftsmanship for everyday office use.",

    features: [
      "Document Organizer",
      "Laptop Sleeve",
      "Premium Handle",
      "Metal Zippers",
    ],

    material: "Premium PU Leather",
    size: "41 × 30 × 11 cm",
    weight: 1.15,
    compartments: 4,

    colors: ["#000000", "#795548", "#424242"],

    inStock: true,
    isBestSeller: true,
    isNewArrival: false,
  ),

  ProductModel(
    id: "OB004",
    name: "Modern Business Laptop Bag",
    category: "Office",
    brand: "Chamunda",

    galleryImages: [
      "assets/images/products/office_bag4.png",
      "assets/images/products/office_bag2.png",
      "assets/images/products/office_bag3.png",
    ],

    price: 2799,
    oldPrice: 3499,
    discount: 20,

    rating: 4.9,
    reviewCount: 358,

    description:
        "Premium business laptop bag with shockproof protection, USB charging port, and luxury finish for professionals.",

    features: [
      "USB Charging Port",
      "Shockproof Laptop Sleeve",
      "Water Resistant",
      "Travel Friendly",
    ],

    material: "Oxford + PU Leather",
    size: "43 × 32 × 13 cm",
    weight: 1.30,
    compartments: 6,

    colors: ["#263238", "#000000", "#4E342E"],

    inStock: true,
    isBestSeller: true,
    isNewArrival: true,
  ),
];
