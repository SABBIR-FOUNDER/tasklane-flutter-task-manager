import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../services/storage_service.dart';
import '../main_screen.dart';
import 'login_screen.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({
    super.key,
  });


  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();

}



class _SplashScreenState
    extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();

    _checkAuthentication();
  }



  Future<void> _checkAuthentication() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );


    final loggedIn =
    await StorageService.isLoggedIn();



    if (!mounted) return;



    if (loggedIn) {


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const MainScreen(),

        ),

      );


    } else {


      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const LoginScreen(),

        ),

      );


    }

  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [


          Positioned.fill(

            child: SvgPicture.asset(

              AppAssets.splashBackground,

              fit:
              BoxFit.cover,

            ),

          ),




          SafeArea(

            child: Center(

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,


                children: [



                  SvgPicture.asset(

                    AppAssets.logoMark,

                    width:
                    120,

                    height:
                    120,

                  ),




                  const SizedBox(
                    height: 24,
                  ),




                  const Text(

                    'TaskLane',

                    style:
                    TextStyle(

                      fontSize:
                      34,

                      fontWeight:
                      FontWeight.w700,

                      color:
                      AppColors.textPrimary,

                      letterSpacing:
                      -0.5,

                    ),

                  ),





                  const SizedBox(
                    height: 8,
                  ),





                  const Text(

                    'Plan. Track. Complete.',

                    style:
                    TextStyle(

                      fontSize:
                      15,

                      fontWeight:
                      FontWeight.w500,

                      color:
                      AppColors.textSecondary,

                      letterSpacing:
                      0.4,

                    ),

                  ),





                  const SizedBox(
                    height: 44,
                  ),





                  const SizedBox(

                    width:
                    28,


                    height:
                    28,


                    child:
                    CircularProgressIndicator(

                      strokeWidth:
                      2.6,


                      color:
                      AppColors.primary,

                    ),

                  ),



                ],

              ),

            ),

          ),


        ],

      ),

    );

  }

}