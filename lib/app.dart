import 'package:flutter/material.dart';
import 'package:tasklane/screens/auth/login_screen.dart';
import 'core/app_theme.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';




class TaskLaneApp extends StatelessWidget {
  const TaskLaneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskLane',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}