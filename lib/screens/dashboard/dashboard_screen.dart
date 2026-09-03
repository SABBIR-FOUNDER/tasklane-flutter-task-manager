import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/profile_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<ProfileProvider>()
          .loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TaskLane',
        ),
      ),
      body: Center(
        child: Consumer<ProfileProvider>(
          builder: (
              context,
              provider,
              child,
              ) {

            if (provider.isLoading) {
              return const CircularProgressIndicator();
            }

            if (provider.profile == null) {
              return const Text(
                'Unable to load profile',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              );
            }

            return Text(
              'Hello, ${provider.profile!.firstName} 👋😚',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            );
          },
        ),
      ),
    );
  }
}