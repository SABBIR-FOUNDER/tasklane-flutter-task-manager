import 'package:flutter/material.dart';

import '../models/task_model.dart';


class TaskCard extends StatelessWidget {

  final TaskModel task;
  final VoidCallback onComplete;
  final VoidCallback onDelete;


  const TaskCard({
    super.key,
    required this.task,
    required this.onComplete,
    required this.onDelete,
  });


  @override
  Widget build(BuildContext context) {

    return Card(

      margin: const EdgeInsets.only(
        bottom: 12,
      ),


      child: Padding(

        padding:
        const EdgeInsets.all(16),


        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children: [


            Row(

              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,


              children: [


                Expanded(
                  child: Text(
                    task.title,

                    style:
                    const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),


                Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),


                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(20),

                    color:
                    Colors.blue.shade100,
                  ),


                  child: Text(
                    task.status,
                  ),

                ),

              ],

            ),


            const SizedBox(
              height: 10,
            ),


            Text(
              task.description,
            ),


            const SizedBox(
              height: 14,
            ),


            Row(

              mainAxisAlignment:
              MainAxisAlignment.end,


              children: [


                IconButton(

                  onPressed:
                  onComplete,

                  icon:
                  const Icon(
                    Icons.check_circle_outline,
                  ),

                ),



                IconButton(

                  onPressed:
                  onDelete,

                  icon:
                  const Icon(
                    Icons.delete_outline,
                  ),

                ),


              ],

            ),

          ],

        ),

      ),

    );

  }

}