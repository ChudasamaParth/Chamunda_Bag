import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userData;

  bool _isLoading = false;

  Map<String, dynamic>? get userData => _userData;

  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    final user = _auth.currentUser;

    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        _userData = doc.data();
      }
    } catch (e) {
      debugPrint('Profile loading error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}