import 'package:chamunda_bag/authentication/forgot_pass_screen.dart';
import 'package:chamunda_bag/authentication/sign_up_screen.dart';
import 'package:chamunda_bag/data/product_data/product_data.dart';
import 'package:chamunda_bag/screens/main_screen.dart';
import 'package:chamunda_bag/provider/wishlist_provider..dart';
import 'package:chamunda_bag/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/app_colors.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      await context.read<WishlistProvider>().loadWishlist(allProducts);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? "Login failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(22, 40, 22, 30),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 250,
                    height: 250,
                  ),
                ),

                Center(
                  child: Text(
                    "Welcome Back",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    "Continue your journey with Chamunda Bag",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 38),

                CustomTextField(
                  controller: _emailController,
                  label: "Email Address",
                  hint: "Enter your email",
                  prefixIcon: Icons.email_outlined,

                  keyboardType: TextInputType.emailAddress,

                  textInputAction: TextInputAction.next,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }

                    if (!value.contains('@')) {
                      return "Please enter a valid email";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: _passwordController,
                  label: "Password",
                  hint: "Enter your password",
                  prefixIcon: Icons.lock_outline_rounded,

                  obscureText: _obscurePassword,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },

                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),

                  textInputAction: TextInputAction.done,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }

                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }

                    return null;
                  },
                ),

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgotPasswordScreen();
                          },
                        ),
                      );
                    },

                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                    ),

                    child: Text(
                      "Forgot Password?",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: auth.isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        .5,
                      ),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: auth.isLoading
                        ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),

                      child: Text(
                        "OR",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Google authentication later.
                    },

                    icon: const Icon(Icons.g_mobiledata_rounded, size: 30),

                    label: Text(
                      "Continue with Google",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,

                      side: BorderSide(color: Colors.grey.shade300),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      "Don't have an account?",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },

                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
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
