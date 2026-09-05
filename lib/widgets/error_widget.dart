import 'package:flutter/material.dart';


class ErrorMessageWidget extends StatelessWidget {

  final String message;


  const ErrorMessageWidget({
    super.key,
    required this.message,
  });



  @override
  Widget build(BuildContext context) {

    return Center(

      child: Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children: [


          const Icon(
            Icons.error_outline,
            size: 50,
          ),


          const SizedBox(
            height: 12,
          ),


          Text(
            message,
            textAlign:
            TextAlign.center,
          ),


        ],

      ),

    );

  }

}