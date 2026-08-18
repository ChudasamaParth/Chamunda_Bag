import 'package:chamunda_bag/screens/cart/cart_screen.dart';
import 'package:chamunda_bag/screens/home/home_screen.dart';
import 'package:chamunda_bag/screens/profile/profile_screen.dart';
import 'package:chamunda_bag/screens/wishlist/wishlist_screen.dart';
import 'package:chamunda_bag/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = const [
      HomeScreen(),
      WishlistScreen(),
      CartScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),

      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
