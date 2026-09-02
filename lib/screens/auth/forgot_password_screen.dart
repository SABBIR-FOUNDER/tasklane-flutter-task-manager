import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_background.dart';

import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    super.key,
  });

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final TextEditingController _emailController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  void _onTapContinue() {

    if (_formKey.currentState!.validate()) {
      final String email =
      _emailController.text.trim();
      debugPrint(
        'Recovery email: $email',
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const OtpVerificationScreen(),
        ),
      );

    }

  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: SvgPicture.asset(
                      AppAssets.forgotPassword,
                      width: 220,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Enter your email address and we will continue with the account recovery process.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon:
                    Icons.email_outlined,
                    keyboardType:
                    TextInputType.emailAddress,
                    textInputAction:
                    TextInputAction.done,
                    validator: _validateEmail,
                  ),

                  const SizedBox(height: 28),

                  PrimaryButton(
                    text: 'Continue',
                    onPressed: _onTapContinue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}