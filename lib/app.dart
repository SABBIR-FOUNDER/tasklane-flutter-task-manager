import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'screens/auth/splash_screen.dart';


class TaskLaneApp extends StatelessWidget {

  const TaskLaneApp({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'TaskLane',

      debugShowCheckedModeBanner: false,


      theme:
      AppTheme.lightTheme,


      home:
      const SplashScreen(),

    );

  }

}