import 'package:flutter/material.dart';

import '../core/app_colors.dart';


class DashboardHeader extends StatelessWidget {

  final String name;


  const DashboardHeader({
    super.key,
    required this.name,
  });



  @override
  Widget build(BuildContext context) {

    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,


      children: [


        Text(

          'Hello, $name 👋',

          style:
          const TextStyle(

            fontSize: 28,

            fontWeight:
            FontWeight.w700,

            color:
            AppColors.textPrimary,

          ),

        ),



        const SizedBox(
          height: 8,
        ),



        const Text(

          'Let’s complete your goals today',

          style:
          TextStyle(

            fontSize: 15,

            color:
            AppColors.textSecondary,

          ),

        ),


      ],

    );

  }

}