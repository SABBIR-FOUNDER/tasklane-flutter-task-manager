import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/profile_provider.dart';



class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({
    super.key,
  });


  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();

}



class _EditProfileScreenState
    extends State<EditProfileScreen> {


  late TextEditingController _firstNameController;

  late TextEditingController _lastNameController;

  late TextEditingController _mobileController;



  bool _loading = false;




  @override
  void initState() {

    super.initState();


    final profile =
        context.read<ProfileProvider>().profile;



    _firstNameController =
        TextEditingController(
          text: profile?.firstName ?? '',
        );


    _lastNameController =
        TextEditingController(
          text: profile?.lastName ?? '',
        );


    _mobileController =
        TextEditingController(
          text: profile?.mobile ?? '',
        );


  }




  Future<void> _updateProfile() async {


    setState(() {

      _loading = true;

    });



    final success =
    await context
        .read<ProfileProvider>()
        .updateProfile({

      "firstName":
      _firstNameController.text.trim(),


      "lastName":
      _lastNameController.text.trim(),


      "mobile":
      _mobileController.text.trim(),

    });



    setState(() {

      _loading = false;

    });



    if(success && mounted){

      Navigator.pop(context);


    }


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          'Edit Profile',
        ),

      ),



      body: Padding(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          children: [


            TextField(

              controller:
              _firstNameController,


              decoration:
              const InputDecoration(
                labelText:
                'First Name',
              ),

            ),



            const SizedBox(
              height:16,
            ),



            TextField(

              controller:
              _lastNameController,


              decoration:
              const InputDecoration(
                labelText:
                'Last Name',
              ),

            ),



            const SizedBox(
              height:16,
            ),



            TextField(

              controller:
              _mobileController,


              keyboardType:
              TextInputType.phone,


              decoration:
              const InputDecoration(
                labelText:
                'Mobile',
              ),

            ),



            const SizedBox(
              height:30,
            ),



            SizedBox(

              width:
              double.infinity,


              child:
              ElevatedButton(

                onPressed:
                _loading
                    ? null
                    : _updateProfile,


                child:
                _loading

                    ? const CircularProgressIndicator()

                    : const Text(
                  'Save Changes',
                ),

              ),

            ),


          ],

        ),

      ),

    );

  }





  @override
  void dispose(){

    _firstNameController.dispose();

    _lastNameController.dispose();

    _mobileController.dispose();


    super.dispose();

  }

}