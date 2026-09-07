import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_timer_provider.dart';

Future<void> showTaskTimerSheet(
  BuildContext context,
  TaskModel task,
) async {
  await showModalBottomSheet(
    context: context,
    builder: (_) => _TaskTimerSheet(task: task),
  );
}

class _TaskTimerSheet extends StatefulWidget {
  final TaskModel task;

  const _TaskTimerSheet({
    required this.task,
  });

  @override
  State<_TaskTimerSheet> createState() => _TaskTimerSheetState();
}

class _TaskTimerSheetState extends State<_TaskTimerSheet> {
  int? selectedMinutes;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Start Task Timer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [15, 25, 45, 60].map((value) {
                return ChoiceChip(
                  label: Text(
                    value == 60 ? '1 hour' : '$value min',
                  ),
                  selected: selectedMinutes == value,
                  onSelected: (_) {
                    setState(() {
                      selectedMinutes = value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: selectedMinutes == null
                  ? null
                  : () {
                context
                    .read<TaskTimerProvider>()
                    .startTimer(

                  taskId:
                  widget.task.id,


                  taskTitle:
                  widget.task.title,


                  durationSeconds:
                  selectedMinutes! * 60,

                );
                      Navigator.pop(context);
                    },
              child: const Text('Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
