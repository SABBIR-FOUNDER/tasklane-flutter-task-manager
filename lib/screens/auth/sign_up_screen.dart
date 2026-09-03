import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_background.dart';

import '../../widgets/custom_text_field.dart';

import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController =
  TextEditingController();

  final TextEditingController _lastNameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _mobileController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final GlobalKey<FormState> _formKey =       //Signup form
      GlobalKey<FormState>();


  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;   //2 password box hide or show 🤗


  String? _validateFirstName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your first name';
    }

    return null;
  }
  String? _validateLastName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your last name';
    }

    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    if (value.length < 10) {
      return 'Please enter a valid mobile number';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

//Confirm password to check if they are same
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }
  void _togglePasswordVisibility() {             //Hide/unhide
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword =
      !_obscureConfirmPassword;
    });
  }


  void _onTapSignUp() async {

    if (_formKey.currentState!.validate()) {

      final data = {
        "email":
        _emailController.text.trim(),

        "firstName":
        _firstNameController.text.trim(),

        "lastName":
        _lastNameController.text.trim(),

        "mobile":
        _mobileController.text.trim(),

        "password":
        _passwordController.text,
      };


      final success =
      await context
          .read<AuthProvider>()
          .register(
        data,
      );


      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const LoginScreen(),
          ),
        );
      }

    }

  }

    @override
    void dispose() {
      _firstNameController.dispose();
      _lastNameController.dispose();
      _emailController.dispose();
      _mobileController.dispose();
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

                  const SizedBox(height: 12),

                  Center(
                    child: SvgPicture.asset(
                      AppAssets.logoMark,
                      width: 82,
                      height: 82,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Create an account to start organizing your tasks.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  CustomTextField(
                    controller: _firstNameController,
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    prefixIcon: Icons.person_outline,
                    textCapitalization:
                    TextCapitalization.words,
                    validator:
                    _validateFirstName,
                  ),


                  CustomTextField(
                    controller: _lastNameController,
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    prefixIcon: Icons.person_outline,
                    textCapitalization:
                    TextCapitalization.words,
                    validator:
                    _validateLastName,
                  ),



                  const SizedBox(height: 18),

                  CustomTextField(

                    controller: _emailController,
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon:
                    Icons.email_outlined,
                    keyboardType:
                    TextInputType.emailAddress,
                    textInputAction:
                    TextInputAction.next,
                    validator:
                    _validateEmail,
                  ),

                  CustomTextField(
                    controller: _mobileController,
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number',
                    prefixIcon:
                    Icons.phone_android_outlined,
                    keyboardType:
                    TextInputType.phone,
                    validator:
                    _validateMobile,
                  ),

                  const SizedBox(height: 18),

                  CustomTextField(
                    controller:
                    _passwordController,
                    labelText:
                    'Password',
                    hintText:
                    'Create a password',
                    prefixIcon:
                    Icons.lock_outline_rounded,
                    obscureText:
                    _obscurePassword,
                    textInputAction:
                    TextInputAction.next,
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
                    controller: _confirmPasswordController,
                    labelText: 'Confirm Password',
                    hintText: 'Enter your password again',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    validator: _validateConfirmPassword,
                    suffixIcon: IconButton(
                      onPressed: _toggleConfirmPasswordVisibility,
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  PrimaryButton(
                    text: 'Create Account',
                    onPressed: _onTapSignUp,
                  ),

                  const SizedBox(height: 22),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color:
                          AppColors.textSecondary,
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign in',
                        ),
                      ),
                    ],
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

