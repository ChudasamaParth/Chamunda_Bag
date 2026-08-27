import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isAdmin = false;
  bool _isLoading = false;

  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;

  Future<void> checkAdminStatus() async {
    final user = _auth.currentUser;

    if (user == null) {
      _isAdmin = false;
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      debugPrint('==========================');
      debugPrint('CURRENT USER UID: ${user.uid}');

      final doc = await _firestore.collection('admin').doc(user.uid).get();

      debugPrint('ADMIN DOC EXISTS: ${doc.exists}');
      debugPrint('ADMIN DATA: ${doc.data()}');

      _isAdmin = doc.exists && doc.data()?['role'] == 'admin';

      debugPrint('IS ADMIN: $_isAdmin');
      debugPrint('==========================');
    } catch (e) {
      debugPrint('Admin check error: $e');
      _isAdmin = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAdminStatus() {
    _isAdmin = false;
    _isLoading = false;
    notifyListeners();
  }
}
