import 'package:chamunda_bag/Admin/AdminDashboard.dart';
import 'package:chamunda_bag/authentication/login_screen.dart';
import 'package:chamunda_bag/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/admin_provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _checkedAdmin = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authProvider = context.read<AuthProvider>();

    if (authProvider.isLoggedIn && !_checkedAdmin) {
      _checkedAdmin = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AdminProvider>().checkAdminStatus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final adminProvider = context.watch<AdminProvider>();

    // User is not logged in
    if (!authProvider.isLoggedIn) {
      return const LoginScreen();
    }

    // Wait while checking admin role
    if (!_checkedAdmin || adminProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Admin
    if (adminProvider.isAdmin) {
      return const AdminDashboard();
    }

    // Normal user
    return const HomeScreen();
  }
}
