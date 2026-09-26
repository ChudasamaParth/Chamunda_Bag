import 'package:chamunda_bag/authentication/login_screen.dart';
import 'package:chamunda_bag/main.dart';
import 'package:chamunda_bag/models/order_model.dart';
import 'package:chamunda_bag/provider/admin_order_provider.dart';
import 'package:chamunda_bag/provider/admin_provider.dart';
import 'package:chamunda_bag/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOrderProvider>().loadOrders();
    });
  }

  Widget build(BuildContext context) {
    final orderProvider = context.watch<AdminOrderProvider>();
    final orders = orderProvider.orders;

    final placedOrders = orders
        .where((order) => order.orderStatus == 'placed')
        .length;

    final shippedOrders = orders
        .where((order) => order.orderStatus == 'shipped')
        .length;

    final deliveredOrders = orders
        .where((order) => order.orderStatus == 'delivered')
        .length;
    return Scaffold(
      backgroundColor: AppColors.background,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          await context.read<AuthProvider>().logout();

          context.read<AdminProvider>().clearAdminStatus();

          if (!context.mounted) return;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        },
        child: const Icon(Icons.logout, color: Colors.white),
      ),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,

        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/brand_icon.png", height: 60, width: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 10, 0, 0),
                  child: Text(
                    'Manage your store',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  "Admin",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 12,
                    letterSpacing: 2,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary,
              child: const Icon(
                Icons.admin_panel_settings_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),

            /// Statistics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.5,
              children: [
                _DashboardCard(
                  title: 'Total Orders',
                  value: orders.length.toString(),
                  icon: Icons.shopping_bag_outlined,
                ),

                _DashboardCard(
                  title: 'Placed',
                  value: placedOrders.toString(),
                  icon: Icons.pending_actions_outlined,
                ),

                _DashboardCard(
                  title: 'Shipped',
                  value: shippedOrders.toString(),
                  icon: Icons.local_shipping_outlined,
                ),

                _DashboardCard(
                  title: 'Delivered',
                  value: deliveredOrders.toString(),
                  icon: Icons.check_circle_outline,
                ),
              ],
            ),

            const SizedBox(height: 30),

            Text(
              'Recent Orders',
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 16),

            if (orderProvider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (orders.isEmpty)
              const _EmptyOrders()
            else
              ...orders.take(5).map((order) => _AdminOrderCard(order: order)),
          ],
        ),
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  final OrderModel order;

  const _AdminOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.orderStatus.toLowerCase() == 'delivered';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.fullName,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${order.totalItems} item(s) • ₹${order.total.toStringAsFixed(0)}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              _buildStatus(order.orderStatus),
            ],
          ),

          const SizedBox(height: 14),

          if (!isDelivered)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  try {
                    await context.read<AdminOrderProvider>().markAsDelivered(
                      order,
                    );

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Order marked as delivered'),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update order')),
                    );
                  }
                },
                icon: const Icon(Icons.check_circle_outline, size: 18),
                label: const Text('Mark as Delivered'),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Delivered',
                  style: GoogleFonts.poppins(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatus(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'placed':
        color = Colors.orange;
        break;

      case 'confirmed':
        color = Colors.blue;
        break;

      case 'shipped':
        color = Colors.deepPurple;
        break;

      case 'delivered':
        color = Colors.green;
        break;

      case 'cancelled':
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 45,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            'No orders available',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 4),

          Text(
            'Orders from customers will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
