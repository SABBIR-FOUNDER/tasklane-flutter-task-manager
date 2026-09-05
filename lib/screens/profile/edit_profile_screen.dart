import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../providers/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
  });

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  late final TextEditingController
      _emailController;
  late final TextEditingController
      _firstNameController;
  late final TextEditingController
      _lastNameController;
  late final TextEditingController
      _mobileController;

  @override
  void initState() {
    super.initState();

    final profile =
        context.read<ProfileProvider>().profile;

    _emailController = TextEditingController(
      text: profile?.email ?? '',
    );

    _firstNameController =
        TextEditingController(
      text: profile?.firstName ?? '',
    );

    _lastNameController =
        TextEditingController(
      text: profile?.lastName ?? '',
    );

    _mobileController =
        TextEditingController(
      text: profile?.mobile ?? '',
    );
  }

  Future<void> _updateProfile() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider =
        context.read<ProfileProvider>();

    final success =
        await provider.updateProfile({
      'email':
          _emailController.text.trim(),
      'firstName':
          _firstNameController.text.trim(),
      'lastName':
          _lastNameController.text.trim(),
      'mobile':
          _mobileController.text.trim(),
    });

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            provider.errorMessage ??
                'Unable to update profile',
          ),
        ),
      );

      return;
    }

    Navigator.pop(
      context,
      true,
    );
  }

  String? _required(
    String? value,
    String field,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $field';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            32,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(
                    18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding:
                            const EdgeInsets.all(
                          11,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                        child:
                            SvgPicture.asset(
                          AppAssets.logoMark,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              'Edit your profile',
                              style: TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 19,
                                fontWeight:
                                    FontWeight
                                        .w700,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'Keep your TaskLane details up to date.',
                              style: TextStyle(
                                color: Color(
                                  0xFFDCE6FF,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller:
                      _emailController,
                  readOnly: true,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Email Address',
                    prefixIcon: Icon(
                      Icons
                          .mail_outline_rounded,
                    ),
                    helperText:
                        'Email is kept as your account identity',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller:
                      _firstNameController,
                  textCapitalization:
                      TextCapitalization.words,
                  textInputAction:
                      TextInputAction.next,
                  validator: (value) =>
                      _required(
                    value,
                    'your first name',
                  ),
                  decoration:
                      const InputDecoration(
                    labelText:
                        'First Name',
                    prefixIcon: Icon(
                      Icons
                          .person_outline_rounded,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller:
                      _lastNameController,
                  textCapitalization:
                      TextCapitalization.words,
                  textInputAction:
                      TextInputAction.next,
                  validator: (value) =>
                      _required(
                    value,
                    'your last name',
                  ),
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Last Name',
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller:
                      _mobileController,
                  keyboardType:
                      TextInputType.phone,
                  textInputAction:
                      TextInputAction.done,
                  validator: (value) =>
                      _required(
                    value,
                    'your mobile number',
                  ),
                  onFieldSubmitted: (_) {
                    if (!provider.isUpdating) {
                      _updateProfile();
                    }
                  },
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Mobile Number',
                    prefixIcon: Icon(
                      Icons.phone_outlined,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed:
                        provider.isUpdating
                            ? null
                            : _updateProfile,
                    child:
                        provider.isUpdating
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      2.3,
                                ),
                              )
                            : const Text(
                                'Save Changes',
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

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();

    super.dispose();
  }
}
