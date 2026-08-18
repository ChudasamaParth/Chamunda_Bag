import 'package:chamunda_bag/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Temporary logic.
    // Real password-reset API/Firebase will be connected later.
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password reset link sent to your email")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(22, 24, 22, 30),

          child: Form(
            key: _formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // BACK BUTTON
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 2,

                  child: InkWell(
                    customBorder: const CircleBorder(),

                    onTap: () {
                      Navigator.pop(context);
                    },

                    child: const SizedBox(
                      height: 46,
                      width: 46,

                      child: Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                    ),
                  ),
                ),

                const SizedBox(height: 55),

                // ICON
                Center(
                  child: Container(
                    height: 90,
                    width: 90,

                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.10),
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.lock_reset_rounded,
                      size: 46,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // TITLE
                Center(
                  child: Text(
                    "Forgot Password?",
                    textAlign: TextAlign.center,

                    style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Text(
                    "No worries. Enter your email address\n"
                    "and we'll help you reset your password.",
                    textAlign: TextAlign.center,

                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                const SizedBox(height: 38),

                // EMAIL
                CustomTextField(
                  controller: _emailController,
                  label: "Email Address",
                  hint: "Enter your registered email",
                  prefixIcon: Icons.email_outlined,

                  keyboardType: TextInputType.emailAddress,

                  textInputAction: TextInputAction.done,

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

                const SizedBox(height: 28),

                // RESET BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendResetLink,

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

                    child: _isLoading
                        ? const SizedBox(
                            height: 23,
                            width: 23,

                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Send Reset Link",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                // BACK TO LOGIN
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: Text(
                      "Back to Login",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
