import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../providers/profile_provider.dart';
import '../../providers/task_provider.dart';

import '../../widgets/task_card.dart';

import '../task/create_task_screen.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}


class _DashboardScreenState
    extends State<DashboardScreen> {


  @override
  void initState() {
    super.initState();

    Future.microtask(() {

      _loadDashboard();

    });
  }


  Future<void> _loadDashboard() async {

    context
        .read<ProfileProvider>()
        .loadProfile();


    context
        .read<TaskProvider>()
        .loadTasks(
      'New',
    );


    context
        .read<TaskProvider>()
        .loadTaskCount();

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'TaskLane',
        ),
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
              const CreateTaskScreen(),
            ),
          );

        },

        child: const Icon(
          Icons.add,
        ),

      ),



      body: RefreshIndicator(

        onRefresh: _loadDashboard,


        child: Padding(
          padding:
          const EdgeInsets.all(20),


          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,


            children: [


              // Greeting

              Consumer<ProfileProvider>(

                builder: (
                    context,
                    provider,
                    child,
                    ) {


                  if(provider.profile == null){

                    return const Text(
                      'Hello 👋',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.textPrimary,
                      ),
                    );

                  }


                  return Text(
                    'Hello, ${provider.profile!.firstName} 👋',

                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      AppColors.textPrimary,
                    ),

                  );


                },

              ),



              const SizedBox(
                height: 30,
              ),



              // Task Count

              Consumer<TaskProvider>(

                builder: (
                    context,
                    provider,
                    child,
                    ) {


                  if(provider.count == null){

                    return const SizedBox();

                  }


                  return Row(

                    children: [


                      Expanded(

                        child: Card(

                          child: Padding(

                            padding:
                            const EdgeInsets.all(20),


                            child: Column(

                              children: [


                                const Text(
                                  'New',
                                ),


                                Text(

                                  '${provider.count!.newTask}',

                                  style:
                                  const TextStyle(
                                    fontSize: 28,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),

                                ),


                              ],

                            ),

                          ),

                        ),

                      ),



                      const SizedBox(
                        width: 12,
                      ),



                      Expanded(

                        child: Card(

                          child: Padding(

                            padding:
                            const EdgeInsets.all(20),


                            child: Column(

                              children: [


                                const Text(
                                  'Completed',
                                ),


                                Text(

                                  '${provider.count!.completedTask}',

                                  style:
                                  const TextStyle(
                                    fontSize: 28,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),

                                ),


                              ],

                            ),

                          ),

                        ),

                      ),


                    ],

                  );


                },

              ),



              const SizedBox(
                height: 30,
              ),



              const Text(

                'New Tasks',

                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.w700,
                  color:
                  AppColors.textPrimary,
                ),

              ),



              const SizedBox(
                height: 16,
              ),



              Expanded(

                child: Consumer<TaskProvider>(

                  builder: (
                      context,
                      provider,
                      child,
                      ) {


                    if(provider.isLoading){

                      return const Center(

                        child:
                        CircularProgressIndicator(),

                      );

                    }



                    if(provider.tasks.isEmpty){

                      return ListView(

                        children: const [

                          SizedBox(
                            height: 150,
                          ),


                          Center(

                            child: Text(
                              'No tasks yet',
                              style:
                              TextStyle(
                                fontSize: 16,
                              ),
                            ),

                          ),

                        ],

                      );

                    }



                    return ListView.builder(

                      itemCount:
                      provider.tasks.length,


                      itemBuilder:
                          (context,index){


                        final task =
                        provider.tasks[index];



                        return TaskCard(

                          task: task,


                          onComplete: () {

                            context
                                .read<TaskProvider>()
                                .updateTaskStatus(
                              task.id,
                              'Completed',
                            );

                          },


                          onDelete: () {

                            context
                                .read<TaskProvider>()
                                .deleteTask(
                              task.id,
                            );

                          },

                        );


                      },

                    );


                  },

                ),

              ),


            ],

          ),

        ),

      ),

    );

  }

}