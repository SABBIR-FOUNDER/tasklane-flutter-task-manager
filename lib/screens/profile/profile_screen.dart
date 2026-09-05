import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../providers/profile_provider.dart';
import '../../services/storage_service.dart';

import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider =
      context.read<ProfileProvider>();

      if (provider.profile == null) {
        provider.loadProfile();
      }
    });
  }

  Future<void> _openEditProfile() async {
    final updated =
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const EditProfileScreen(),
      ),
    );

    if (!mounted) {
      return;
    }

    if (updated == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Profile updated successfully',
          ),
        ),
      );
    }
  }

  Future<void> _showLogoutDialog() async {
    final shouldLogout =
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
          ),
          content: const Text(
            'Are you sure you want to logout from TaskLane?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Logout',
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await StorageService.clearToken();

    if (!mounted) {
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
        ),
        centerTitle: false,
      ),
      body: Consumer<ProfileProvider>(
        builder: (
            context,
            provider,
            child,
            ) {
          if (provider.isLoading &&
              provider.profile == null) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (provider.profile == null) {
            return _ProfileErrorState(
              message:
              provider.errorMessage ??
                  'Unable to load profile',
              onRetry:
              provider.loadProfile,
            );
          }

          final profile =
          provider.profile!;

          final fullName =
          '${profile.firstName} ${profile.lastName}'
              .trim();

          return RefreshIndicator(
            onRefresh:
            provider.loadProfile,
            child: ListView(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding:
              const EdgeInsets.fromLTRB(
                20,
                8,
                20,
                30,
              ),
              children: [
                _ProfileHeader(
                  name: fullName,
                  email: profile.email,
                  initials: _getInitials(
                    profile.firstName,
                    profile.lastName,
                  ),
                ),
                const SizedBox(
                  height: 28,
                ),
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.w700,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                    BorderRadius.circular(
                      20,
                    ),
                    border: Border.all(
                      color:
                      const Color(
                        0xFFE8ECF4,
                      ),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                        Color(
                          0x0D0F172A,
                        ),
                        blurRadius: 20,
                        offset:
                        Offset(
                          0,
                          8,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ProfileInfoRow(
                        icon:
                        Icons
                            .mail_outline_rounded,
                        label:
                        'Email Address',
                        value:
                        profile.email,
                      ),
                      const _ProfileDivider(),
                      _ProfileInfoRow(
                        icon:
                        Icons
                            .phone_outlined,
                        label:
                        'Mobile Number',
                        value:
                        profile.mobile,
                      ),
                      const _ProfileDivider(),
                      _ProfileInfoRow(
                        icon:
                        Icons
                            .calendar_month_outlined,
                        label:
                        'Member Since',
                        value:
                        _formatDate(
                          profile
                              .createdDate,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 26,
                ),
                SizedBox(
                  height: 54,
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    _openEditProfile,
                    icon:
                    SvgPicture.asset(
                      AppAssets.edit,
                      width: 20,
                      height: 20,
                    ),
                    label: const Text(
                      'Edit Profile',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  height: 54,
                  child:
                  OutlinedButton.icon(
                    onPressed:
                    _showLogoutDialog,
                    style:
                    OutlinedButton.styleFrom(
                      foregroundColor:
                      AppColors.danger,
                      side: const BorderSide(
                        color:
                        Color(
                          0xFFFECACA,
                        ),
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                    ),
                    icon:
                    SvgPicture.asset(
                      AppAssets.logout,
                      width: 20,
                      height: 20,
                    ),
                    label: const Text(
                      'Logout',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getInitials(
      String firstName,
      String lastName,
      ) {
    final first =
    firstName.trim().isNotEmpty
        ? firstName
        .trim()
        .substring(0, 1)
        : '';

    final last =
    lastName.trim().isNotEmpty
        ? lastName
        .trim()
        .substring(0, 1)
        : '';

    final initials =
    '$first$last'.toUpperCase();

    return initials.isEmpty
        ? 'TL'
        : initials;
  }

  String _formatDate(
      Object? value,
      ) {
    if (value == null) {
      return 'Not available';
    }

    DateTime? date;

    if (value is DateTime) {
      date = value;
    } else {
      date =
          DateTime.tryParse(
            value.toString(),
          );
    }

    if (date == null) {
      return value.toString();
    }

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }
}

class _ProfileHeader
    extends StatelessWidget {
  final String name;
  final String email;
  final String initials;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        boxShadow: const [
          BoxShadow(
            color:
            Color(
              0x1A2563EB,
            ),
            blurRadius: 30,
            offset:
            Offset(
              0,
              12,
            ),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
        BorderRadius.circular(
          24,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child:
              SvgPicture.asset(
                AppAssets.profileAccent,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.all(
                22,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets
                            .logoMarkWhite,
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(
                        width: 9,
                      ),
                      const Text(
                        'TaskLane',
                        style: TextStyle(
                          color:
                          Colors.white,
                          fontSize: 17,
                          fontWeight:
                          FontWeight
                              .w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .center,
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        alignment:
                        Alignment.center,
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                        ),
                        child: Text(
                          initials,
                          style:
                          const TextStyle(
                            fontSize: 23,
                            fontWeight:
                            FontWeight
                                .w800,
                            color:
                            AppColors
                                .primary,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              name,
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              const TextStyle(
                                fontSize:
                                22,
                                fontWeight:
                                FontWeight
                                    .w800,
                                color:
                                Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              email,
                              maxLines: 1,
                              overflow:
                              TextOverflow
                                  .ellipsis,
                              style:
                              const TextStyle(
                                fontSize:
                                13,
                                color:
                                Color(
                                  0xFFE8ECFF,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.all(
        18,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration:
            BoxDecoration(
              color:
              const Color(
                0xFFEEF4FF,
              ),
              borderRadius:
              BorderRadius.circular(
                13,
              ),
            ),
            child: Icon(
              icon,
              color:
              AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(
            width: 14,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  label,
                  style:
                  const TextStyle(
                    color:
                    AppColors
                        .textSecondary,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  value,
                  style:
                  const TextStyle(
                    color:
                    AppColors
                        .textPrimary,
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDivider
    extends StatelessWidget {
  const _ProfileDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 76,
      color: Color(
        0xFFEEF1F6,
      ),
    );
  }
}

class _ProfileErrorState
    extends StatelessWidget {
  final String message;
  final Future<void> Function()
  onRetry;

  const _ProfileErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize:
          MainAxisSize.min,
          children: [
            const Icon(
              Icons
                  .person_off_outlined,
              size: 52,
              color:
              AppColors.textSecondary,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Unable to load profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              message,
              textAlign:
              TextAlign.center,
              style: const TextStyle(
                color:
                AppColors
                    .textSecondary,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            ElevatedButton(
              onPressed: onRetry,
              child:
              const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}