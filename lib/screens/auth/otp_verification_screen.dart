import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_background.dart';

import 'reset_password_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
  });

  @override
  State<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();

}

class _OtpVerificationScreenState
    extends State<OtpVerificationScreen> {
  bool _isLoading = false;

  final TextEditingController _otpController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  static const int otpLength = 4;
  String? _validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter the verification code';
    }

    if (value.trim().length != otpLength) {
      return 'Please enter a valid verification code';
    }

    return null;
  }

  void _onTapVerify() {

    if (_formKey.currentState!.validate()) {

      final String otp =
      _otpController.text.trim();


      debugPrint(
        'OTP entered: $otp',
      );


      Navigator.push(
        context,
        MaterialPageRoute(
          builder:(context)=>
          const ResetPasswordScreen(),
        ),
      );

    }

  }

  @override
  void dispose() {
    _otpController.dispose();
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
                      AppAssets.otpShield,
                      width: 220,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Verify your account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Enter the verification code sent for your account recovery.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  TextFormField(
                    controller: _otpController,
                    keyboardType:
                    TextInputType.number,
                    maxLength: otpLength,
                    textInputAction:
                    TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly,
                    ],
                    decoration:
                    const InputDecoration(
                      labelText:
                      'Verification Code',
                      hintText:
                      'Enter verification code',
                      prefixIcon: Icon(
                        Icons.pin_outlined,
                      ),
                    ),
                    validator: _validateOtp,
                  ),

                  const SizedBox(height: 28),

                  PrimaryButton(
                    text: 'Verify',
                    onPressed: _onTapVerify,
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