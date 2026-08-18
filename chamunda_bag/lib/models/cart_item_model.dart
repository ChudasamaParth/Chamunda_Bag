import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;

  double get totalOldPrice => product.oldPrice * quantity;

  int get totalDiscount =>
      ((totalOldPrice - totalPrice) * 100 / totalOldPrice).round();
}
