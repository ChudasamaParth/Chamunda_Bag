import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get isLoggedIn => _auth.currentUser != null;

  AuthProvider() {
    _user = _auth.currentUser;

    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  // ─────────────────────────────────────
  // LOGIN
  // ─────────────────────────────────────

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = credential.user;

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─────────────────────────────────────
  // SIGN UP
  // ─────────────────────────────────────

  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Create Firebase Authentication user
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        _errorMessage = "Unable to create account.";
        return false;
      }

      // Store user profile in Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // ─────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────

  Future<void> logout() async {
    await _auth.signOut();

    _user = null;
    notifyListeners();
  }

  // ─────────────────────────────────────
  // PASSWORD RESET
  // ─────────────────────────────────────

  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      await _auth.sendPasswordResetEmail(email: email);

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ─────────────────────────────────────
  // LOADING
  // ─────────────────────────────────────

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ─────────────────────────────────────
  // FIREBASE ERRORS
  // ─────────────────────────────────────

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'user-not-found':
        return 'No account found with this email.';

      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'weak-password':
        return 'Password is too weak.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
