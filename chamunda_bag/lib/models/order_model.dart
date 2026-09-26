import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_item_model.dart';

class OrderModel {
  final String id;
  final String userId;

  final List<OrderItemModel> items;

  // Address snapshot
  final String fullName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String pincode;

  // Price
  final double subtotal;
  final double shipping;
  final double total;

  // Payment
  final String paymentMethod;
  final String paymentStatus;

  // Order status
  final String orderStatus;

  // Order status history
  final Map<String, DateTime> statusHistory;

  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.fullName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.pincode,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.statusHistory,
    required this.createdAt,
  });

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,

      'items': items.map((item) => item.toMap()).toList(),

      // Address
      'fullName': fullName,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'pincode': pincode,

      // Price
      'subtotal': subtotal,
      'shipping': shipping,
      'total': total,

      // Payment
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,

      // Order
      'orderStatus': orderStatus,

      // Status history
      'statusHistory': statusHistory.map(
        (key, value) => MapEntry(key, Timestamp.fromDate(value)),
      ),

      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    final historyMap =
        Map<String, dynamic>.from(map['statusHistory'] ?? {});

    final statusHistory = <String, DateTime>{};

    historyMap.forEach((key, value) {
      if (value is Timestamp) {
        statusHistory[key] = value.toDate();
      } else if (value is DateTime) {
        statusHistory[key] = value;
      }
    });

    return OrderModel(
      id: id,

      userId: map['userId'] ?? '',

      items: (map['items'] as List<dynamic>? ?? [])
          .map(
            (item) => OrderItemModel.fromMap(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList(),

      // Address
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',

      // Price
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      shipping: (map['shipping'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),

      // Payment
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',

      // Order
      orderStatus: map['orderStatus'] ?? '',

      // Status history
      statusHistory: statusHistory,

      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] is DateTime
              ? map['createdAt']
              : DateTime.parse(
                  map['createdAt'].toString(),
                ),
    );
  }
}