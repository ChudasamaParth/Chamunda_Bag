import 'package:chamunda_bag/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<AddressModel> _addresses = [];

  bool _isLoading = false;

  List<AddressModel> get addresses => List.unmodifiable(_addresses);

  bool get isLoading => _isLoading;

  /// Current user's UID
  String? get _userId => _auth.currentUser?.uid;

  /// Default address
  AddressModel? get defaultAddress {
    try {
      return _addresses.firstWhere((address) => address.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  /// Firestore addresses collection
  CollectionReference<Map<String, dynamic>> get _addressCollection {
    final userId = _userId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    return _firestore.collection('users').doc(userId).collection('addresses');
  }

  // ============================================================
  // LOAD ADDRESSES
  // ============================================================

  Future<void> loadAddresses() async {
    final userId = _userId;

    if (userId == null) {
      _addresses.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .get();

      _addresses.clear();

      for (final doc in snapshot.docs) {
        _addresses.add(AddressModel.fromMap(doc.id, doc.data()));
      }
    } catch (e) {
      debugPrint('Error loading addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // ADD ADDRESS
  // ============================================================

  Future<void> addAddress(AddressModel address) async {
    final userId = _userId;

    if (userId == null) {
      throw Exception('User is not logged in');
    }

    try {
      _isLoading = true;
      notifyListeners();

      final collection = _addressCollection;

      /*
       * If this is the first address, automatically make it default.
       */
      final shouldBeDefault = _addresses.isEmpty || address.isDefault;

      /*
       * If this address is going to be default,
       * remove default status from existing addresses.
       */
      if (shouldBeDefault) {
        await _removeDefaultFromExistingAddresses();
      }

      final doc = collection.doc();

      final newAddress = address.copyWith(
        id: doc.id,
        isDefault: shouldBeDefault,
      );

      await doc.set(newAddress.toMap());

      _addresses.add(newAddress);
    } catch (e) {
      debugPrint('Error adding address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // UPDATE ADDRESS
  // ============================================================

  Future<void> updateAddress(AddressModel address) async {
    if (_userId == null) {
      throw Exception('User is not logged in');
    }

    try {
      _isLoading = true;
      notifyListeners();

      if (address.isDefault) {
        await _removeDefaultFromExistingAddresses(exceptId: address.id);
      }

      await _addressCollection.doc(address.id).update(address.toMap());

      final index = _addresses.indexWhere((item) => item.id == address.id);

      if (index != -1) {
        _addresses[index] = address;
      }
    } catch (e) {
      debugPrint('Error updating address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // DELETE ADDRESS
  // ============================================================

  Future<void> deleteAddress(String addressId) async {
    if (_userId == null) {
      throw Exception('User is not logged in');
    }

    try {
      _isLoading = true;
      notifyListeners();

      final address = _addresses.firstWhere((item) => item.id == addressId);

      await _addressCollection.doc(addressId).delete();

      _addresses.removeWhere((item) => item.id == addressId);

      /*
       * If the deleted address was the default address,
       * make another address default.
       */
      if (address.isDefault && _addresses.isNotEmpty) {
        final newDefault = _addresses.first;

        await _addressCollection.doc(newDefault.id).update({'isDefault': true});

        final index = _addresses.indexWhere((item) => item.id == newDefault.id);

        if (index != -1) {
          _addresses[index] = _addresses[index].copyWith(isDefault: true);
        }
      }
    } catch (e) {
      debugPrint('Error deleting address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // SET DEFAULT ADDRESS
  // ============================================================

  Future<void> setDefaultAddress(String addressId) async {
    if (_userId == null) {
      throw Exception('User is not logged in');
    }

    try {
      _isLoading = true;
      notifyListeners();

      await _removeDefaultFromExistingAddresses(exceptId: addressId);

      await _addressCollection.doc(addressId).update({'isDefault': true});

      for (int i = 0; i < _addresses.length; i++) {
        _addresses[i] = _addresses[i].copyWith(
          isDefault: _addresses[i].id == addressId,
        );
      }
    } catch (e) {
      debugPrint('Error setting default address: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============================================================
  // REMOVE DEFAULT FROM EXISTING ADDRESSES
  // ============================================================

  Future<void> _removeDefaultFromExistingAddresses({String? exceptId}) async {
    final batch = _firestore.batch();

    bool hasChanges = false;

    for (final address in _addresses) {
      if (address.isDefault && address.id != exceptId) {
        batch.update(_addressCollection.doc(address.id), {'isDefault': false});

        hasChanges = true;
      }
    }

    if (hasChanges) {
      await batch.commit();
    }

    for (int i = 0; i < _addresses.length; i++) {
      if (_addresses[i].id != exceptId) {
        _addresses[i] = _addresses[i].copyWith(isDefault: false);
      }
    }
  }

  // ============================================================
  // CLEAR LOCAL DATA
  // ============================================================

  void clearAddresses() {
    _addresses.clear();
    notifyListeners();
  }
}
