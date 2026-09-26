import 'package:chamunda_bag/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<OrderModel> _orders = [];
  bool _isLoading = false;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot =
          await _firestore.collectionGroup('orders').get();

      _orders = snapshot.docs.map((doc) {
        debugPrint('ORDER ID: ${doc.id}');
        debugPrint('ORDER DATA: ${doc.data()}');

        return OrderModel.fromMap(
          doc.id,
          doc.data(),
        );
      }).toList();

      _orders.sort(
        (a, b) => b.createdAt.compareTo(a.createdAt),
      );

      debugPrint(
        'ADMIN ORDERS LOADED: ${_orders.length}',
      );
    } catch (e) {
      debugPrint('Admin load orders error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsDelivered(OrderModel order) async {
    try {
      final now = DateTime.now();

      await _firestore
          .collection('users')
          .doc(order.userId)
          .collection('orders')
          .doc(order.id)
          .update({
        'orderStatus': 'delivered',
        'statusHistory.delivered':
            Timestamp.fromDate(now),
      });

      final index = _orders.indexWhere(
        (item) => item.id == order.id,
      );

      if (index != -1) {
        final oldOrder = _orders[index];

        _orders[index] = OrderModel(
          id: oldOrder.id,
          userId: oldOrder.userId,
          items: oldOrder.items,
          fullName: oldOrder.fullName,
          phone: oldOrder.phone,
          address: oldOrder.address,
          city: oldOrder.city,
          state: oldOrder.state,
          pincode: oldOrder.pincode,
          subtotal: oldOrder.subtotal,
          shipping: oldOrder.shipping,
          total: oldOrder.total,
          paymentMethod: oldOrder.paymentMethod,
          paymentStatus: oldOrder.paymentStatus,
          orderStatus: 'delivered',
          createdAt: oldOrder.createdAt,

          statusHistory: {
            ...oldOrder.statusHistory,
            'delivered': now,
          },
        );

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Mark delivered error: $e');
      rethrow;
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }
}