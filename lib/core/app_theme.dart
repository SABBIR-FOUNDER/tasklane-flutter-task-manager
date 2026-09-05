import 'package:flutter/material.dart';

import 'app_colors.dart';


class AppTheme {

  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,


    scaffoldBackgroundColor:
    AppColors.background,


    colorScheme:
    ColorScheme.fromSeed(
      seedColor:
      AppColors.primary,
    ),


    appBarTheme:
    const AppBarTheme(

      elevation:
      0,

      centerTitle:
      false,

      backgroundColor:
      AppColors.background,

      foregroundColor:
      AppColors.textPrimary,

    ),



    cardTheme:
    CardThemeData(

      elevation:
      2,

      color:
      AppColors.card,


      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(
          16,
        ),

      ),

    ),



    inputDecorationTheme:
    InputDecorationTheme(

      filled:
      true,


      fillColor:
      Colors.white,


      border:
      OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(
          14,
        ),

        borderSide:
        BorderSide.none,

      ),

    ),


    elevatedButtonTheme:
    ElevatedButtonThemeData(

      style:
      ElevatedButton.styleFrom(

        minimumSize:
        const Size(
          double.infinity,
          50,
        ),


        shape:
        RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(
            14,
          ),

        ),

      ),

    ),

  );

}