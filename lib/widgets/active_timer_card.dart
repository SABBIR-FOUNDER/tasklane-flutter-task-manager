
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_timer_provider.dart';


class ActiveTimerCard extends StatelessWidget {

  const ActiveTimerCard({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

    return Consumer<TaskTimerProvider>(
      builder: (
        context,
        provider,
        child,
      ) {

        if(provider.timer == null) {
          return const SizedBox.shrink();
        }


        return Card(
          child: Padding(
            padding:
                const EdgeInsets.all(16),
            child: Column(
              children: [

                Text(
                  provider.timer!.taskTitle,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  provider.displayForTask(
                    provider.timer!.taskId,
                  ),
                  style:
                      const TextStyle(
                    fontSize: 34,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Row(
                  children: [

                    Expanded(
                      child:
                          FilledButton(
                        onPressed:
                            provider.isRunning
                                ? provider.pauseTimer
                                : provider.resumeTimer,
                        child: Text(
                          provider.isRunning
                              ? 'Pause'
                              : 'Resume',
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(
                      child:
                          OutlinedButton(
                        onPressed:
                            provider.stopTimer,
                        child:
                            const Text(
                          'Stop',
                        ),
                      ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        );

      },
    );

  }

}
