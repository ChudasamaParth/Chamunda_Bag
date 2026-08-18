class AddressModel {
  final String id;
  final String fullName;
  final String phone;
  final String addressLine;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.isDefault = false,
  });

  /// Convert AddressModel → Firestore
  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'isDefault': isDefault,
    };
  }

  /// Convert Firestore → AddressModel
  factory AddressModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return AddressModel(
      id: id,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      addressLine: map['addressLine'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pincode: map['pincode'] ?? '',
      landmark: map['landmark'],
      isDefault: map['isDefault'] ?? false,
    );
  }

  AddressModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? addressLine,
    String? city,
    String? state,
    String? pincode,
    String? landmark,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      landmark: landmark ?? this.landmark,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}