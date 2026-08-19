import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final VoidCallback? onTap;

  const UserAvatar({super.key, this.onTap});

  String _getInitial(User? user) {
    if (user == null) {
      return '';
    }

    final name = user.displayName?.trim();

    if (name != null && name.isNotEmpty) {
      return name[0].toUpperCase();
    }

    final email = user.email?.trim();

    if (email != null && email.isNotEmpty) {
      return email[0].toUpperCase();
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final initial = _getInitial(user);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromARGB(255, 41, 22, 9).withValues(alpha: 0.10),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.20),
            width: 1,
          ),
        ),
        child: Center(
          child: initial.isEmpty
              ? Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,

                  size: 23,
                )
              : Text(
                  initial,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 123, 86, 60),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
