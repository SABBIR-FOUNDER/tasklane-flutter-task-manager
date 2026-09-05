import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/constants/task_status.dart';
import '../../providers/task_provider.dart';

class CreateTaskScreen
    extends StatefulWidget {
  const CreateTaskScreen({
    super.key,
  });

  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState
    extends State<CreateTaskScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _titleController =
      TextEditingController();

  final TextEditingController
      _descriptionController =
      TextEditingController();

  String _status = TaskStatus.newTask;

  bool _loading = false;

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    final success =
        await context
            .read<TaskProvider>()
            .createTask({
      'title':
          _titleController.text.trim(),
      'description':
          _descriptionController.text.trim(),
      'status': _status,
    });

    if (!mounted) {
      return;
    }

    setState(() {
      _loading = false;
    });

    if (!success) {
      final message =
          context
              .read<TaskProvider>()
              .error;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            message ??
                'Unable to create task',
          ),
        ),
      );

      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              SvgPicture.asset(
                AppAssets
                    .taskCreatedSuccess,
                height: 110,
              ),
              const SizedBox(height: 18),
              const Text(
                'Task Created!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w700,
                  color:
                      AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The task is now in '
                '$_status.',
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color:
                      AppColors.textSecondary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text('Done'),
            ),
          ],
        );
      },
    );

    if (mounted) {
      Navigator.pop(
        context,
        true,
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Create Task'),
      ),
      body: SafeArea(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Center(
                  child:
                      SvgPicture.asset(
                    AppAssets.addTask,
                    height: 72,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Create a new task',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add the task details and choose its current status.',
                  style: TextStyle(
                    height: 1.5,
                    color:
                        AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller:
                      _titleController,
                  textInputAction:
                      TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter a task title';
                    }

                    return null;
                  },
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Task Title',
                    hintText:
                        'Enter task title',
                    border:
                        OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller:
                      _descriptionController,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null ||
                        value
                            .trim()
                            .isEmpty) {
                      return 'Please enter a description';
                    }

                    return null;
                  },
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Description',
                    hintText:
                        'Enter task description',
                    alignLabelWithHint:
                        true,
                    border:
                        OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<
                    String>(
                  initialValue: _status,
                  decoration:
                      const InputDecoration(
                    labelText:
                        'Task Status',
                    border:
                        OutlineInputBorder(),
                  ),
                  items: TaskStatus.values
                      .map(
                    (status) {
                      return DropdownMenuItem<
                          String>(
                        value: status,
                        child: Text(status),
                      );
                    },
                  ).toList(),
                  onChanged: _loading
                      ? null
                      : (value) {
                          if (value ==
                              null) {
                            return;
                          }

                          setState(() {
                            _status =
                                value;
                          });
                        },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Available statuses: New, In Progress, Completed and Cancelled.',
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width:
                      double.infinity,
                  height: 52,
                  child:
                      ElevatedButton.icon(
                    onPressed: _loading
                        ? null
                        : _submitTask,
                    icon: _loading
                        ? const SizedBox
                            .shrink()
                        : SvgPicture.asset(
                            AppAssets
                                .addTask,
                            width: 21,
                            height: 21,
                          ),
                    label: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.4,
                            ),
                          )
                        : const Text(
                            'Create Task',
                          ),
                  ),
                ),
              ],
            ),
          ),
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
