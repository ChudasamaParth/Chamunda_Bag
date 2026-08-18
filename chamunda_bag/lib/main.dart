import 'package:chamunda_bag/provider/address_provider.dart';
import 'package:chamunda_bag/provider/auth_provider.dart';
import 'package:chamunda_bag/firebase_options.dart';
import 'package:chamunda_bag/provider/cart_provider.dart';
import 'package:chamunda_bag/provider/order_provider.dart';
import 'package:chamunda_bag/provider/profile_provider.dart';
import 'package:chamunda_bag/provider/review_provider.dart';
import 'package:chamunda_bag/provider/wishlist_provider..dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()),

        ChangeNotifierProvider(create: (_) => CartProvider()),

        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const ChamundaBagApp(),
    ),
  );
}

class ChamundaBagApp extends StatelessWidget {
  const ChamundaBagApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chamunda Bag',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
