import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';

import '../../providers/profile_provider.dart';

import '../../services/storage_service.dart';

import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';



class ProfileScreen extends StatelessWidget {

  const ProfileScreen({
    super.key,
  });



  Future<void> _logout(
      BuildContext context,
      ) async {


    await StorageService.clearToken();



    if(context.mounted){


      Navigator.pushAndRemoveUntil(


        context,


        MaterialPageRoute(

          builder: (_) =>
          const LoginScreen(),

        ),


            (route) => false,


      );


    }


  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar:

      AppBar(

        title:

        const Text(

          'Profile',

        ),


      ),







      body:

      Consumer<ProfileProvider>(


        builder:(

            context,

            provider,

            child,

            ){



          final profile =
              provider.profile;





          if(profile == null){


            return const Center(

              child:

              CircularProgressIndicator(),

            );


          }







          return SingleChildScrollView(



            padding:

            const EdgeInsets.all(20),




            child:

            Column(



              crossAxisAlignment:

              CrossAxisAlignment.center,



              children: [





                SvgPicture.asset(

                  AppAssets.profileAccent,


                  height:140,


                ),






                const SizedBox(

                  height:20,

                ),






                Text(



                  '${profile.firstName} ${profile.lastName}',




                  textAlign:

                  TextAlign.center,




                  style:

                  const TextStyle(



                    fontSize:28,



                    fontWeight:

                    FontWeight.w700,



                    color:

                    AppColors.textPrimary,



                  ),




                ),







                const SizedBox(

                  height:30,

                ),






                Card(


                  child:

                  Padding(



                    padding:

                    const EdgeInsets.all(20),




                    child:

                    Column(



                      children: [




                        _infoTile(

                          'Email',

                          profile.email,

                        ),






                        _infoTile(

                          'Mobile',

                          profile.mobile,

                        ),






                        _infoTile(

                          'Account Created',

                          profile.createdDate
                              .toString(),

                        ),



                      ],



                    ),



                  ),



                ),








                const SizedBox(

                  height:30,

                ),






                SizedBox(



                  width:

                  double.infinity,




                  child:

                  ElevatedButton.icon(



                    onPressed: () {



                      Navigator.push(



                        context,



                        MaterialPageRoute(



                          builder: (_) =>

                          const EditProfileScreen(),



                        ),



                      );



                    },





                    icon:



                    SvgPicture.asset(



                      AppAssets.edit,



                      width:22,



                      height:22,



                    ),





                    label:



                    const Text(



                      'Edit Profile',



                    ),



                  ),



                ),







                const SizedBox(

                  height:12,

                ),








                SizedBox(



                  width:

                  double.infinity,




                  child:

                  ElevatedButton.icon(



                    onPressed: () {



                      _logout(

                        context,

                      );



                    },





                    icon:



                    SvgPicture.asset(



                      AppAssets.logout,



                      width:22,



                      height:22,



                    ),





                    label:



                    const Text(



                      'Logout',



                    ),



                  ),



                ),




              ],




            ),




          );




        },



      ),



    );

  }







  Widget _infoTile(

      String title,

      String value,

      ){



    return Padding(



      padding:

      const EdgeInsets.only(

        bottom:16,

      ),





      child:

      Column(



        crossAxisAlignment:

        CrossAxisAlignment.start,




        children: [





          Text(



            title,



            style:

            const TextStyle(



              fontWeight:

              FontWeight.w600,



              color:

              AppColors.textSecondary,



            ),



          ),






          const SizedBox(

            height:6,

          ),







          Text(



            value,



            style:

            const TextStyle(



              fontSize:16,



              color:

              AppColors.textPrimary,



            ),



          ),




        ],



      ),



    );



  }



}