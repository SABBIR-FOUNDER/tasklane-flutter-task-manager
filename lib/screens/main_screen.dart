import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/constants/task_status.dart';

import 'dashboard/dashboard_screen.dart';
import 'profile/profile_screen.dart';
import 'task/create_task_screen.dart';
import 'task/task_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedNavIndex = 0;
  String _taskStatus = TaskStatus.newTask;

  Future<void> _openCreateTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const CreateTaskScreen(),
      ),
    );
  }

  void _openTasks(
    String status,
  ) {
    setState(() {
      _taskStatus = status;
      _selectedNavIndex = 1;
    });
  }

  void _onDestinationSelected(
    int index,
  ) {
    if (index == 2) {
      _openCreateTask();
      return;
    }

    setState(() {
      _selectedNavIndex = index;
    });
  }

  Widget _currentScreen() {
    switch (_selectedNavIndex) {
      case 1:
        return TaskListScreen(
          key: ValueKey(_taskStatus),
          status: _taskStatus,
        );
      case 3:
        return const ProfileScreen();
      case 0:
      default:
        return DashboardScreen(
          onCreateTask: _openCreateTask,
          onOpenTasks: _openTasks,
        );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: _currentScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex:
            _selectedNavIndex,
        backgroundColor:
            AppColors.card,
        indicatorColor:
            AppColors.purpleSoft,
        onDestinationSelected:
            _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home_outlined,
            ),
            selectedIcon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.task_alt_outlined,
            ),
            selectedIcon: Icon(
              Icons.task_alt_rounded,
            ),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.add_circle_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.add_circle_rounded,
            ),
            label: 'Add',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_rounded,
            ),
            selectedIcon: Icon(
              Icons.person_rounded,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
