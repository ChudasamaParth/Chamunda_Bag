import 'package:chamunda_bag/authentication/login_screen.dart';
import 'package:chamunda_bag/provider/auth_provider.dart';
import 'package:chamunda_bag/screens/check_out/adreess_screen.dart';
import 'package:chamunda_bag/screens/check_out/my_order_screen.dart';
import 'package:chamunda_bag/screens/home/home_screen.dart';
import 'package:chamunda_bag/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileProvider>();

    if (profile.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final data = profile.userData;

    if (data == null) {
      return const Scaffold(body: Center(child: Text("Create Your Account ")));
    }

    final name = data['name'] ?? 'User';
    final email = data['email'] ?? '';
    final phone = data['phone'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MainScreen();
                },
              ),
            );
          },
        ),
        centerTitle: false,
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROFILE HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 48,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    name,
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // PERSONAL INFORMATION
            _sectionTitle("Personal Information"),

            const SizedBox(height: 10),

            _profileTile(
              icon: Icons.person_outline_rounded,
              title: "Full Name",
              value: name,
            ),

            _profileTile(
              icon: Icons.email_outlined,
              title: "Email",
              value: email,
            ),

            _profileTile(
              icon: Icons.phone_outlined,
              title: "Phone",
              value: phone,
            ),

            const SizedBox(height: 20),

            // ACCOUNT
            _sectionTitle("Account"),

            const SizedBox(height: 10),

            _actionTile(
              icon: Icons.shopping_bag_outlined,
              title: "My Orders",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
                );
              },
            ),
            _actionTile(
              icon: Icons.shopping_bag_outlined,
              title: "My Address",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddressScreen()),
                );
              },
            ),

            _actionTile(
              icon: Icons.settings_outlined,
              title: "Settings",
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              trailing: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.red,
              ),
              onTap: _showSignOutDialog,
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Sign Out?',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Are you sure you want to sign out of your account?',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await context.read<AuthProvider>().logout();

                if (!mounted) return;

                // Navigate to login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _profileTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      ),
    );
  }
}
