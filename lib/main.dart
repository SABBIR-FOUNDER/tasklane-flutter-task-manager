import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';

import 'providers/auth_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/task_provider.dart';
import 'providers/task_timer_provider.dart';



void main() {

  WidgetsFlutterBinding.ensureInitialized();


  runApp(

    MultiProvider(

      providers: [


        ChangeNotifierProvider(

          create: (_) =>
              TaskProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>
              AuthProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) =>
              ProfileProvider(),

        ),



        ChangeNotifierProvider(

          create: (_) {

            final provider =
            TaskTimerProvider();


            Future.microtask(() {

              provider.initialize();

            });


            return provider;

          },

        ),



      ],


      child:

      const TaskLaneApp(),


    ),

  );

}