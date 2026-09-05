import 'package:flutter/material.dart';



class PrimaryButton extends StatelessWidget {

  final String text;

  final VoidCallback? onPressed;

  final bool isLoading;


  const PrimaryButton({

    super.key,

    required this.text,

    required this.onPressed,

    this.isLoading = false,

  });



  @override
  Widget build(BuildContext context) {

    return ElevatedButton(

      onPressed:
      isLoading
          ? null
          : onPressed,


      child:

      isLoading

          ? const SizedBox(

        width: 22,

        height: 22,


        child:
        CircularProgressIndicator(

          strokeWidth: 2.3,

          color:
          Colors.white,

        ),

      )


          : Text(

        text,


        style:
        const TextStyle(

          fontSize: 16,

          fontWeight:
          FontWeight.w600,


        ),

      ),

    );

  }

}