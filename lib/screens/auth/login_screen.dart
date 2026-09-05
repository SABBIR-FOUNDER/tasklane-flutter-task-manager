import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';

import '../../providers/auth_provider.dart';

import '../../widgets/primary_button.dart';
import '../../widgets/screen_background.dart';

import '../main_screen.dart';
import 'sign_up_screen.dart';



class LoginScreen extends StatefulWidget {

  const LoginScreen({
    super.key,
  });


  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();

}



class _LoginScreenState
    extends State<LoginScreen> {


  final TextEditingController _emailController =
  TextEditingController();


  final TextEditingController _passwordController =
  TextEditingController();



  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();


  bool _obscurePassword = true;


  bool _isLoading = false;



  Future<void> _onTapLogin() async {


    if(!_formKey.currentState!.validate()){

      return;

    }


    setState(() {

      _isLoading = true;

    });



    try {


      await context
          .read<AuthProvider>()
          .login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );



      if(!mounted) return;



      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const MainScreen(),

        ),

      );



    } catch(e) {


      if(!mounted) return;



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:

          Text(
            e.toString(),
          ),

        ),

      );


    }



    if(mounted){

      setState(() {

        _isLoading = false;

      });

    }


  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:

      ScreenBackground(

        child:

        SafeArea(

          child:

          SingleChildScrollView(

            padding:
            const EdgeInsets.all(24),



            child:

            Form(

              key:
              _formKey,



              child:

              Column(

                children: [



                  const SizedBox(
                    height:40,
                  ),




                  SvgPicture.asset(

                    AppAssets.logoMark,

                    width:
                    100,

                    height:
                    100,

                  ),





                  const SizedBox(
                    height:20,
                  ),





                  SvgPicture.asset(

                    AppAssets.authWelcomeRoad,

                    height:
                    120,

                  ),





                  const SizedBox(
                    height:25,
                  ),





                  const Text(

                    'Welcome Back',

                    style:

                    TextStyle(

                      fontSize:
                      30,

                      fontWeight:
                      FontWeight.bold,

                      color:
                      AppColors.textPrimary,

                    ),

                  ),





                  const SizedBox(
                    height:8,
                  ),





                  const Text(

                    'Sign in to manage your tasks',

                    style:

                    TextStyle(

                      color:
                      AppColors.textSecondary,

                    ),

                  ),





                  const SizedBox(
                    height:30,
                  ),





                  TextFormField(

                    controller:
                    _emailController,


                    validator:(value){

                      if(value == null ||
                          value.isEmpty){

                        return 'Enter email';

                      }

                      return null;

                    },


                    decoration:

                    const InputDecoration(

                      labelText:
                      'Email',

                    ),

                  ),





                  const SizedBox(
                    height:16,
                  ),





                  TextFormField(

                    controller:
                    _passwordController,


                    obscureText:
                    _obscurePassword,


                    validator:(value){

                      if(value == null ||
                          value.isEmpty){

                        return 'Enter password';

                      }

                      return null;

                    },


                    decoration:

                    InputDecoration(

                      labelText:
                      'Password',




                      suffixIcon:

                      IconButton(

                        onPressed:(){

                          setState((){

                            _obscurePassword =
                            !_obscurePassword;

                          });


                        },



                        icon:

                        Icon(

                          _obscurePassword

                              ? Icons.visibility

                              : Icons.visibility_off,

                        ),

                      ),

                    ),

                  ),





                  const SizedBox(
                    height:25,
                  ),





                  PrimaryButton(

                    text:
                    'Login',


                    isLoading:
                    _isLoading,


                    onPressed:
                    _onTapLogin,

                  ),





                  TextButton(

                    onPressed:(){


                      Navigator.push(

                        context,


                        MaterialPageRoute(

                          builder:(_)=>

                          const SignUpScreen(),

                        ),

                      );


                    },



                    child:

                    const Text(

                      'Create account',

                    ),

                  ),



                ],

              ),

            ),

          ),

        ),

      ),

    );

  }





  @override
  void dispose(){

    _emailController.dispose();

    _passwordController.dispose();


    super.dispose();

  }

}