import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';


class CreateTaskScreen extends StatefulWidget {

  const CreateTaskScreen({
    super.key,
  });


  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();

}


class _CreateTaskScreenState
    extends State<CreateTaskScreen> {


  final TextEditingController _titleController =
  TextEditingController();


  final TextEditingController _descriptionController =
  TextEditingController();


  bool _loading = false;


  Future<void> _createTask() async {

    setState(() {
      _loading = true;
    });


    final data = {

      "title":
      _titleController.text.trim(),

      "description":
      _descriptionController.text.trim(),

      "status":
      "New",

    };


    final success =
    await context
        .read<TaskProvider>()
        .createTask(
      data,
    );


    setState(() {
      _loading = false;
    });


    if(success && mounted){

      Navigator.pop(
        context,
      );

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'Create Task',
        ),
      ),


      body: Padding(

        padding:
        const EdgeInsets.all(20),


        child: Column(

          children: [


            TextField(
              controller:
              _titleController,

              decoration:
              const InputDecoration(
                labelText:
                'Title',
              ),

            ),


            const SizedBox(
              height: 16,
            ),


            TextField(
              controller:
              _descriptionController,

              decoration:
              const InputDecoration(
                labelText:
                'Description',
              ),

              maxLines:
              4,

            ),


            const SizedBox(
              height: 24,
            ),


            ElevatedButton(

              onPressed:
              _loading
                  ? null
                  : _createTask,


              child:
              _loading
                  ? const CircularProgressIndicator()
                  : const Text(
                'Create Task',
              ),

            ),

          ],

        ),

      ),

    );

  }


  @override
  void dispose() {

    _titleController.dispose();

    _descriptionController.dispose();

    super.dispose();

  }

}