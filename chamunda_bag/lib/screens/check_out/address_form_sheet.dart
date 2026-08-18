import 'package:chamunda_bag/models/address_model.dart';
import 'package:chamunda_bag/provider/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class AddressFormSheet extends StatefulWidget {
  final AddressModel? address;

  const AddressFormSheet({
    super.key,
    this.address,
  });

  bool get isEditing => address != null;

  @override
  State<AddressFormSheet> createState() => _AddressFormSheetState();
}

class _AddressFormSheetState extends State<AddressFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;

  bool _isDefault = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final address = widget.address;

    _nameController = TextEditingController(
      text: address?.fullName ?? '',
    );

    _phoneController = TextEditingController(
      text: address?.phone ?? '',
    );

    _addressController = TextEditingController(
      text: address?.addressLine ?? '',
    );

    _cityController = TextEditingController(
      text: address?.city ?? '',
    );

    _stateController = TextEditingController(
      text: address?.state ?? '',
    );

    _pincodeController = TextEditingController(
      text: address?.pincode ?? '',
    );

    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();

    super.dispose();
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final provider = context.read<AddressProvider>();

      final address = AddressModel(
        id: widget.address?.id ?? '',
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        addressLine: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        isDefault: _isDefault,
      );

      if (widget.isEditing) {
        await provider.updateAddress(address);
      } else {
        await provider.addAddress(address);
      }

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Address updated successfully'
                : 'Address added successfully',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save address'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: Colors.grey.shade600,
      ),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 1.2,
        ),
      ),
    );
  }

  String? _requiredValidator(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return '$field is required';
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) {
      return 'Enter a valid 10-digit phone number';
    }

    return null;
  }

  String? _pincodeValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }

    if (!RegExp(r'^[0-9]{6}$').hasMatch(value.trim())) {
      return 'Enter a valid 6-digit pincode';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  widget.isEditing
                      ? 'Edit Address'
                      : 'Add New Address',
                  style: GoogleFonts.poppins(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  'Enter your delivery details',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 22),

                // Name
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: _inputDecoration(
                    hint: 'Full name',
                    icon: Icons.person_outline,
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'Name'),
                ),

                const SizedBox(height: 14),

                // Phone
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: _inputDecoration(
                    hint: 'Phone number',
                    icon: Icons.phone_outlined,
                  ).copyWith(
                    counterText: '',
                  ),
                  validator: _phoneValidator,
                ),

                const SizedBox(height: 14),

                // Address
                TextFormField(
                  controller: _addressController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  decoration: _inputDecoration(
                    hint: 'House no., street, area',
                    icon: Icons.location_on_outlined,
                  ),
                  validator: (value) =>
                      _requiredValidator(value, 'Address'),
                ),

                const SizedBox(height: 14),

                // City + State
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        textCapitalization:
                            TextCapitalization.words,
                        decoration: _inputDecoration(
                          hint: 'City',
                          icon: Icons.location_city_outlined,
                        ),
                        validator: (value) =>
                            _requiredValidator(value, 'City'),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        textCapitalization:
                            TextCapitalization.words,
                        decoration: _inputDecoration(
                          hint: 'State',
                          icon: Icons.map_outlined,
                        ),
                        validator: (value) =>
                            _requiredValidator(value, 'State'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Pincode
                TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: _inputDecoration(
                    hint: 'Pincode',
                    icon: Icons.pin_drop_outlined,
                  ).copyWith(
                    counterText: '',
                  ),
                  validator: _pincodeValidator,
                ),

                const SizedBox(height: 8),

                // Default address
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: SwitchListTile(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value;
                      });
                    },
                    activeColor: AppColors.primary,
                    title: Text(
                      'Set as default address',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Use this address for future orders',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving
                            ? null
                            : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed:
                            _isSaving ? null : _saveAddress,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                widget.isEditing
                                    ? 'Update Address'
                                    : 'Save Address',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}