import 'package:chamunda_bag/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<OrderModel> _orders = [];

  bool _isLoading = false;

  List<OrderModel> get orders => List.unmodifiable(_orders);

  bool get isLoading => _isLoading;

  /// Create a new order
  Future<void> createOrder(OrderModel order) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    try {
      final orderRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc();

      final orderWithId = OrderModel(
        id: orderRef.id,
        userId: user.uid,
        items: order.items,
        fullName: order.fullName,
        phone: order.phone,
        address: order.address,
        city: order.city,
        state: order.state,
        pincode: order.pincode,
        subtotal: order.subtotal,
        shipping: order.shipping,
        total: order.total,
        paymentMethod: order.paymentMethod,
        paymentStatus: order.paymentStatus,
        orderStatus: order.orderStatus,
        createdAt: order.createdAt,
      );

      await orderRef.set({
        ...orderWithId.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      _orders.insert(0, orderWithId);

      notifyListeners();
    } catch (e) {
      debugPrint('Create order error: $e');
      rethrow;
    }
  }

  /// Load all orders of current user
  Future<void> loadOrders() async {
    final user = _auth.currentUser;

    if (user == null) {
      _orders = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('Loading orders for UID: ${user.uid}');

      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      debugPrint('Orders found: ${snapshot.docs.length}');

      _orders = snapshot.docs
          .map((doc) => OrderModel.fromMap(doc.id, doc.data()))
          .toList();

      debugPrint('Orders loaded successfully: ${_orders.length}');
    } catch (e, stackTrace) {
      debugPrint('Load orders error: $e');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get one order
  Future<OrderModel?> getOrder(String orderId) async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .get();

      if (!doc.exists) {
        return null;
      }

      return OrderModel.fromMap(doc.id, doc.data()!);
    } catch (e) {
      debugPrint('Get order error: $e');
      rethrow;
    }
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': 'cancelled'});

      final index = _orders.indexWhere((order) => order.id == orderId);

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
          orderStatus: 'cancelled',
          createdAt: oldOrder.createdAt,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Cancel order error: $e');
      rethrow;
    }
  }

  /// Clear local order list
  void clearOrders() {
    _orders = [];
    notifyListeners();
  }
}
