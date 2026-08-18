class OrderItemModel {
  final String productId;
  final String productName;
  final String image;
  final double price;
  final int quantity;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.image,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      image: map['image'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
    );
  }
}