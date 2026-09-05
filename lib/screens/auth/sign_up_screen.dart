import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/screen_background.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() =>
      _SignUpScreenState();
}

class _SignUpScreenState
    extends State<SignUpScreen> {
  final TextEditingController
      _firstNameController =
      TextEditingController();

  final TextEditingController
      _lastNameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController
      _mobileController =
      TextEditingController();

  final TextEditingController
      _passwordController =
      TextEditingController();

  final TextEditingController
      _confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  String? _validateFirstName(
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your first name';
    }

    return null;
  }

  String? _validateLastName(
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your last name';
    }

    return null;
  }

  String? _validateEmail(
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validateMobile(
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your mobile number';
    }

    if (value.trim().length < 10) {
      return 'Please enter a valid mobile number';
    }

    return null;
  }

  String? _validatePassword(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }

    if (value.length < 6) {
      return 'Password must contain at least 6 characters';
    }

    return null;
  }

  String? _validateConfirmPassword(
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  Future<void> _onTapSignUp() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success =
          await context
              .read<AuthProvider>()
              .register({
        'email':
            _emailController.text.trim(),
        'firstName':
            _firstNameController.text.trim(),
        'lastName':
            _lastNameController.text.trim(),
        'mobile':
            _mobileController.text.trim(),
        'password':
            _passwordController.text,
      });

      if (!mounted) {
        return;
      }

      if (!success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to create account. Please check your details and try again.',
            ),
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Account created. Please login.',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const LoginScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ScreenBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
            padding:
                const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              26,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        icon: const Icon(
                          Icons
                              .arrow_back_rounded,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: SvgPicture.asset(
                            AppAssets.wordmark,
                            width: 185,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'Create your account',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight:
                          FontWeight.w800,
                      color: AppColors
                          .textPrimary,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  const Text(
                    'Start organizing your work and move every task forward.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller:
                        _firstNameController,
                    labelText:
                        'First Name',
                    hintText:
                        'Enter first name',
                    prefixIcon: Icons
                        .person_outline_rounded,
                    textCapitalization:
                        TextCapitalization
                            .words,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        _validateFirstName,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller:
                        _lastNameController,
                    labelText:
                        'Last Name',
                    hintText:
                        'Enter last name',
                    prefixIcon: Icons
                        .person_outline_rounded,
                    textCapitalization:
                        TextCapitalization
                            .words,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        _validateLastName,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller:
                        _emailController,
                    labelText: 'Email',
                    hintText:
                        'Enter your email',
                    prefixIcon:
                        Icons.email_outlined,
                    keyboardType:
                        TextInputType
                            .emailAddress,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        _validateEmail,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller:
                        _mobileController,
                    labelText:
                        'Mobile Number',
                    hintText:
                        'Enter mobile number',
                    prefixIcon: Icons
                        .phone_android_outlined,
                    keyboardType:
                        TextInputType.phone,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        _validateMobile,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller:
                        _passwordController,
                    labelText:
                        'Password',
                    hintText:
                        'Create a password',
                    prefixIcon: Icons
                        .lock_outline_rounded,
                    obscureText:
                        _obscurePassword,
                    textInputAction:
                        TextInputAction.next,
                    validator:
                        _validatePassword,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword =
                              !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller:
                        _confirmPasswordController,
                    labelText:
                        'Confirm Password',
                    hintText:
                        'Enter password again',
                    prefixIcon: Icons
                        .lock_outline_rounded,
                    obscureText:
                        _obscureConfirmPassword,
                    textInputAction:
                        TextInputAction.done,
                    validator:
                        _validateConfirmPassword,
                    suffixIcon:
                        IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword =
                              !_obscureConfirmPassword;
                        });
                      },
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                    text: 'Create Account',
                    isLoading:
                        _isLoading,
                    onPressed:
                        _onTapSignUp,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child:
                            const Text(
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
}
