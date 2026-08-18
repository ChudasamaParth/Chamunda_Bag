import 'package:chamunda_bag/models/address_model.dart';
import 'package:chamunda_bag/provider/address_provider.dart';
import 'package:chamunda_bag/screens/check_out/address_form_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().loadAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "My Addresses",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddressForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          "Add Address",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),

      body: Consumer<AddressProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.addresses.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            itemCount: provider.addresses.length,
            itemBuilder: (context, index) {
              final address = provider.addresses[index];

              return _buildAddressCard(address, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on_outlined,
                size: 42,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "No saved addresses",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Add an address to make your checkout faster and easier.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => _openAddressForm(),
              icon: const Icon(Icons.add),
              label: const Text("Add Address"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, AddressProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primary.withValues(alpha: .35)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  address.fullName,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Default",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            address.phone,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            "${address.addressLine}, ${address.city}, "
            "${address.state} - ${address.pincode}",
            style: GoogleFonts.poppins(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 14),

          Divider(height: 1, color: Colors.grey.shade200),

          const SizedBox(height: 8),

          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  _openAddressForm(address: address);
                },
                icon: const Icon(Icons.edit_outlined, size: 17),
                label: const Text("Edit"),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),

              TextButton.icon(
                onPressed: () {
                  _deleteAddress(address, provider);
                },
                icon: const Icon(Icons.delete_outline, size: 17),
                label: const Text("Delete"),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),

              const Spacer(),

              if (!address.isDefault)
                TextButton(
                  onPressed: () {
                    provider.setDefaultAddress(address.id);
                  },
                  child: Text(
                    "Set Default",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _openAddressForm({AddressModel? address}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return AddressFormSheet(address: address);
      },
    );
  }

  Future<void> _deleteAddress(
    AddressModel address,
    AddressProvider provider,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Delete address?"),
          content: const Text("This address will be permanently removed."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await provider.deleteAddress(address.id);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Address deleted")));
  }
}
