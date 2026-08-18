import 'package:chamunda_bag/models/address_model.dart';
import 'package:chamunda_bag/models/order_item_model.dart';
import 'package:chamunda_bag/models/order_model.dart';
import 'package:chamunda_bag/provider/address_provider.dart';
import 'package:chamunda_bag/provider/cart_provider.dart';
import 'package:chamunda_bag/provider/order_provider.dart';
import 'package:chamunda_bag/screens/check_out/address_form_sheet.dart';
import 'package:chamunda_bag/screens/check_out/order_success.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  AddressModel? _selectedAddress;

  String _paymentMethod = 'Cash on Delivery';

  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  Future<void> _loadAddresses() async {
    final provider = context.read<AddressProvider>();

    if (provider.addresses.isEmpty) {
      await provider.loadAddresses();
    }

    if (!mounted) return;

    setState(() {
      _selectedAddress = provider.defaultAddress;
    });
  }

  void _selectAddress(AddressModel address) {
    setState(() {
      _selectedAddress = address;
    });
  }

  void _addAddress() async {
    final result = await showModalBottomSheet<AddressModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (context) {
        return const AddressFormSheet();
      },
    );

    if (!mounted || result == null) return;

    await context.read<AddressProvider>().loadAddresses();

    setState(() {
      _selectedAddress = result;
    });
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a delivery address first')),
      );
      return;
    }

    final cart = context.read<CartProvider>();

    if (cart.items.isEmpty) {
      _showMessage('Your cart is empty');
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final address = _selectedAddress!;

      final order = OrderModel(
        id: '',
        userId: '',
        items: cart.items.map((item) {
          return OrderItemModel(
            productId: item.product.id,
            productName: item.product.name,
            image: item.product.thumbnail,
            price: item.product.price,
            quantity: item.quantity,
          );
        }).toList(),
        fullName: address.fullName,
        phone: address.phone,
        address: address.addressLine,
        city: address.city,
        state: address.state,
        pincode: address.pincode,
        subtotal: cart.subtotal,
        shipping: cart.shipping,
        total: cart.total,
        paymentMethod: _paymentMethod,
        paymentStatus: 'pending',
        orderStatus: 'placed',
        createdAt: DateTime.now(),
      );

      await context.read<OrderProvider>().createOrder(order);

      cart.clearCart();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      _showMessage('Failed to place order. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Checkout',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: Consumer2<CartProvider, AddressProvider>(
        builder: (context, cart, addressProvider, child) {
          if (cart.items.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                  'Delivery Address',
                  Icons.location_on_outlined,
                ),

                const SizedBox(height: 12),

                _buildAddressSection(addressProvider),

                const SizedBox(height: 28),

                _buildSectionTitle('Order Items', Icons.shopping_bag_outlined),

                const SizedBox(height: 12),

                _buildOrderItems(cart),

                const SizedBox(height: 28),

                _buildSectionTitle('Payment Method', Icons.payment_outlined),

                const SizedBox(height: 12),

                _buildPaymentSection(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'Price Details',
                  Icons.receipt_long_outlined,
                ),

                const SizedBox(height: 12),

                _buildPriceSummary(cart),
              ],
            ),
          );
        },
      ),

      bottomSheet: _buildBottomBar(),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 21, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection(AddressProvider provider) {
    if (provider.isLoading && provider.addresses.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // No address → show Add Delivery Address button
    if (provider.addresses.isEmpty) {
      return _buildNoAddressState();
    }

    return Column(
      children: [
        ...provider.addresses.map((address) => _buildAddressCard(address)),

        const SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: _addAddress,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add new address'),
            style: TextButton.styleFrom(foregroundColor: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildNoAddressState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 42,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            'No delivery address found',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Add an address to continue with your order.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _addAddress,
              icon: const Icon(Icons.add_location_alt_outlined),
              label: const Text('Add Delivery Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    final isSelected = _selectedAddress?.id == address.id;

    return GestureDetector(
      onTap: () => _selectAddress(address),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.fullName,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      if (address.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: .08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Default',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  Text(
                    address.phone,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${address.addressLine}, '
                    '${address.city}, '
                    '${address.state} - '
                    '${address.pincode}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  if (address.landmark != null &&
                      address.landmark!.trim().isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      'Landmark: ${address.landmark}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(CartProvider cart) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: cart.items.map((item) {
          return Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item.product.thumbnail,
                    height: 65,
                    width: 65,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Qty: ${item.quantity}',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  '₹${item.totalPrice.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _paymentMethod = 'Cash on Delivery';
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary, width: 1.3),
        ),
        child: Row(
          children: [
            Icon(Icons.local_atm_outlined, color: AppColors.primary, size: 28),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash on Delivery',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'Pay when your order arrives',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary(CartProvider cart) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _priceRow('Subtotal', '₹${cart.subtotal.toStringAsFixed(0)}'),

          const SizedBox(height: 10),

          _priceRow(
            'Shipping',
            cart.shipping == 0
                ? 'FREE'
                : '₹${cart.shipping.toStringAsFixed(0)}',
          ),

          const Divider(height: 24),

          _priceRow(
            'Total',
            '₹${cart.total.toStringAsFixed(0)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 15 : 13,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 17 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: _isPlacingOrder
                    ? const SizedBox(
                        height: 23,
                        width: 23,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Place Order • ₹${cart.total.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
