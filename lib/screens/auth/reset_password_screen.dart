import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_background.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();


  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();


  bool _obscurePassword = true;

  bool _obscureConfirmPassword = true;

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }


    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }


    return null;
  }


  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }


    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }


    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword =
      !_obscurePassword;
    });
  }


  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword =
      !_obscureConfirmPassword;
    });
  }

  void _onTapResetPassword() {
    if (_formKey.currentState!.validate()) {
      debugPrint(
        'Password reset successful',
      );


      Navigator.popUntil(
        context,
            (route) => route.isFirst,
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();

    _confirmPasswordController.dispose();


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

                      AppAssets.resetPasswordLock,

                      width: 220,

                    ),

                  ),


                  const SizedBox(height: 28),


                  const Text(

                    'Create new password',

                    style: TextStyle(

                      fontSize: 30,

                      fontWeight:
                      FontWeight.w700,

                      color:
                      AppColors.textPrimary,

                    ),

                  ),


                  const SizedBox(height: 10),


                  const Text(

                    'Create a new password for your account.',

                    style: TextStyle(

                      color:
                      AppColors.textSecondary,

                      height: 1.5,

                    ),

                  ),


                  const SizedBox(height: 32),


                  CustomTextField(

                    controller:
                    _passwordController,

                    labelText:
                    'New Password',

                    hintText:
                    'Enter new password',

                    prefixIcon:
                    Icons.lock_outline_rounded,


                    obscureText:
                    _obscurePassword,


                    validator:
                    _validatePassword,


                    suffixIcon:
                    IconButton(

                      onPressed:
                      _togglePasswordVisibility,


                      icon: Icon(

                        _obscurePassword

                            ? Icons.visibility_outlined

                            : Icons.visibility_off_outlined,

                      ),

                    ),

                  ),


                  const SizedBox(height: 18),


                  CustomTextField(

                    controller:
                    _confirmPasswordController,


                    labelText:
                    'Confirm Password',


                    hintText:
                    'Confirm new password',


                    prefixIcon:
                    Icons.lock_outline_rounded,


                    obscureText:
                    _obscureConfirmPassword,


                    validator:
                    _validateConfirmPassword,


                    suffixIcon:
                    IconButton(

                      onPressed:
                      _toggleConfirmPasswordVisibility,


                      icon: Icon(

                        _obscureConfirmPassword

                            ? Icons.visibility_outlined

                            : Icons.visibility_off_outlined,

                      ),

                    ),

                  ),


                  const SizedBox(height: 28),


                  PrimaryButton(

                    text:
                    'Reset Password',


                    onPressed:
                    _onTapResetPassword,

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
