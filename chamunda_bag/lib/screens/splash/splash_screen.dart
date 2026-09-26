import 'dart:async';

import 'package:chamunda_bag/Admin/AdminDashboard.dart';
import 'package:chamunda_bag/provider/admin_provider.dart';
import 'package:chamunda_bag/provider/auth_provider.dart';
import 'package:chamunda_bag/authentication/login_screen.dart';
import 'package:chamunda_bag/screens/main_screen.dart';
import 'package:chamunda_bag/data/product_data/product_data.dart';
import 'package:chamunda_bag/provider/wishlist_provider..dart';
import 'package:chamunda_bag/provider/cart_provider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../widgets/loading_dots.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final Animation<Offset> _textSlide;
  late final Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoScale = Tween<double>(begin: .7, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(_logoController);

    _textSlide = Tween<Offset>(
      begin: const Offset(0, .35),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(_textController);

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await _logoController.forward();

    await _textController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    await _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    debugPrint('===== SPLASH AUTH CHECK START =====');

    final auth = context.read<AuthProvider>();

    final user = await auth.waitForAuthState();

    debugPrint('SPLASH USER: ${user?.email}');
    debugPrint('SPLASH UID: ${user?.uid}');

    if (!mounted) return;

    if (user == null) {
      debugPrint('SPLASH → LOGIN');
      _goTo(const LoginScreen());
      return;
    }

    debugPrint('SPLASH → USER LOGGED IN');

    try {
      debugPrint('LOADING WISHLIST...');
      await context.read<WishlistProvider>().loadWishlist(allProducts);
      debugPrint('WISHLIST LOADED');

      debugPrint('LOADING CART...');
      await context.read<CartProvider>().loadCart(allProducts);
      debugPrint('CART LOADED');
    } catch (e) {
      debugPrint('ERROR LOADING USER DATA: $e');
    }

    if (!mounted) return;

    debugPrint('CHECKING ADMIN STATUS...');

    final adminProvider = context.read<AdminProvider>();

    await adminProvider.checkAdminStatus();

    debugPrint('IS ADMIN: ${adminProvider.isAdmin}');

    if (!mounted) return;

    if (adminProvider.isAdmin) {
      debugPrint('SPLASH → ADMIN DASHBOARD');
      _goTo(const AdminDashboard());
    } else {
      debugPrint('SPLASH → MAIN SCREEN');
      _goTo(const MainScreen());
    }
  }

  void _goTo(Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          /// Decorative Circle 1
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.04),
              ),
            ),
          ),

          /// Decorative Circle 2
          Positioned(
            bottom: -140,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(.06),
              ),
            ),
          ),

          /// Decorative Circle 3
          Positioned(
            top: 120,
            left: -60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(.025),
              ),
            ),
          ),

          /// Decorative Circle 4
          Positioned(
            bottom: 180,
            right: -40,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(.03),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: SlideTransition(
                        position: _textSlide,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeTransition(
                              opacity: _logoOpacity,
                              child: ScaleTransition(
                                scale: _logoScale,
                                child: Hero(
                                  tag: "app_logo",
                                  child: Image.asset(
                                    AppAssets.logo,
                                    height: 250,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            Text(
                              "Chamunda Bag",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              "Crafted for Every Journey",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            const SizedBox(height: 35),

                            const LoadingDots(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    "EST. 2026",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      letterSpacing: 4,
                      color: Colors.grey.shade500,
                    ),
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
