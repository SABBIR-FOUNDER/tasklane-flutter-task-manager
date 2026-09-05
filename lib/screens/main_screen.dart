import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';
import '../core/constants/task_status.dart';
import 'dashboard/dashboard_screen.dart';
import 'profile/profile_screen.dart';
import 'task/create_task_screen.dart';
import 'task/task_list_screen.dart';

class MainScreen
    extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TaskListScreen(
      status: TaskStatus.newTask,
    ),
    SizedBox.shrink(),
    ProfileScreen(),
  ];

  Future<void> _onDestinationSelected(
    int index,
  ) async {
    if (index == 2) {
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const CreateTaskScreen(),
        ),
      );

      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar:
          NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected:
            _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              AppAssets.home,
              width: 24,
              height: 24,
            ),
            selectedIcon:
                SvgPicture.asset(
              AppAssets.home,
              width: 24,
              height: 24,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              AppAssets.details,
              width: 24,
              height: 24,
            ),
            selectedIcon:
                SvgPicture.asset(
              AppAssets.details,
              width: 24,
              height: 24,
            ),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              AppAssets.addTask,
              width: 24,
              height: 24,
            ),
            selectedIcon:
                SvgPicture.asset(
              AppAssets.addTask,
              width: 24,
              height: 24,
            ),
            label: 'Add',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              AppAssets.profile,
              width: 24,
              height: 24,
            ),
            selectedIcon:
                SvgPicture.asset(
              AppAssets.profile,
              width: 24,
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
