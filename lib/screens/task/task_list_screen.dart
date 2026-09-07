import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/constants/task_status.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';
import '../../providers/task_timer_provider.dart';
import '../../widgets/task_card.dart';

class TaskListScreen
    extends StatefulWidget {
  final String status;

  const TaskListScreen({
    super.key,
    required this.status,
  });

  @override
  State<TaskListScreen> createState() =>
      _TaskListScreenState();
}

class _TaskListScreenState
    extends State<TaskListScreen> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();

    _selectedStatus =
        TaskStatus.values
                .contains(widget.status)
            ? widget.status
            : TaskStatus.newTask;

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context
          .read<TaskProvider>()
          .loadTasks(
            _selectedStatus,
          );
    });
  }

  @override
  void didUpdateWidget(
    covariant TaskListScreen oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.status ==
        widget.status) {
      return;
    }

    if (!TaskStatus.values
        .contains(widget.status)) {
      return;
    }

    _selectedStatus =
        widget.status;

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context
          .read<TaskProvider>()
          .loadTasks(
            _selectedStatus,
          );
    });
  }

  Future<void> _selectStatus(
    String status,
  ) async {
    if (status ==
        _selectedStatus) {
      return;
    }

    setState(() {
      _selectedStatus =
          status;
    });

    await context
        .read<TaskProvider>()
        .loadTasks(
          status,
        );
  }

  Future<void> _changeTaskStatus(
    TaskModel task,
    String newStatus,
  ) async {
    final provider =
        context.read<TaskProvider>();

    final success =
        await provider
            .updateTaskStatus(
      task.id,
      newStatus,
      fromStatus: task.status,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Task moved to $newStatus'
              : provider.error ??
                  'Unable to update task',
        ),
      ),
    );
  }

  Future<void> _deleteTask(
    TaskModel task,
  ) async {
    final confirmed =
        await showDialog<bool>(
      context: context,
      builder: (
        dialogContext,
      ) {
        return AlertDialog(
          title:
              const Text(
            'Delete task?',
          ),
          content: Text(
            'Delete "${task.title}"? '
            'This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text(
                'Delete',
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true ||
        !mounted) {
      return;
    }

    final provider =
        context.read<TaskProvider>();

    final success =
        await provider.deleteTask(
      task.id,
      status: task.status,
    );

    if (success &&
        mounted) {
      await context
          .read<TaskTimerProvider>()
          .stopTimerForTask(
        task.id,
      );
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Task deleted'
              : provider.error ??
                  'Unable to delete task',
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text(
          'Tasks',
        ),
      ),
      body: Column(
        children: [
          Container(
            width:
                double.infinity,
            padding:
                const EdgeInsets
                    .fromLTRB(
              16,
              12,
              16,
              8,
            ),
            child:
                const Text(
              'Filter by status',
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
                color: AppColors
                    .textSecondary,
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child:
                ListView.separated(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 16,
              ),
              scrollDirection:
                  Axis.horizontal,
              itemCount:
                  TaskStatus
                      .values.length,
              separatorBuilder:
                  (
                context,
                index,
              ) {
                return const SizedBox(
                  width: 8,
                );
              },
              itemBuilder:
                  (
                context,
                index,
              ) {
                final status =
                    TaskStatus
                        .values[index];

                return ChoiceChip(
                  label:
                      Text(
                    status,
                  ),
                  selected:
                      status ==
                          _selectedStatus,
                  onSelected: (_) {
                    _selectStatus(
                      status,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child:
                Consumer<TaskProvider>(
              builder: (
                context,
                provider,
                child,
              ) {
                final tasks =
                    provider.tasksFor(
                  _selectedStatus,
                );

                final loading =
                    provider
                        .isLoadingStatus(
                  _selectedStatus,
                );

                final error =
                    provider.errorFor(
                  _selectedStatus,
                );

                if (loading &&
                    tasks.isEmpty) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (error != null &&
                    tasks.isEmpty) {
                  return _ErrorState(
                    message: error,
                    onRetry: () {
                      provider.loadTasks(
                        _selectedStatus,
                      );
                    },
                  );
                }

                if (tasks.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () {
                      return provider
                          .loadTasks(
                        _selectedStatus,
                      );
                    },
                    child: ListView(
                      physics:
                          const AlwaysScrollableScrollPhysics(),
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal:
                            24,
                      ),
                      children: [
                        const SizedBox(
                          height: 90,
                        ),
                        SvgPicture.asset(
                          AppAssets
                              .emptyTasks,
                          height: 140,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'No $_selectedStatus tasks',
                          textAlign:
                              TextAlign
                                  .center,
                          style:
                              const TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .w700,
                            color: AppColors
                                .textPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Tasks in this status will appear here.',
                          textAlign:
                              TextAlign
                                  .center,
                          style:
                              TextStyle(
                            color: AppColors
                                .textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () {
                    return provider
                        .loadTasks(
                      _selectedStatus,
                    );
                  },
                  child:
                      ListView.builder(
                    padding:
                        const EdgeInsets
                            .all(
                      16,
                    ),
                    itemCount:
                        tasks.length,
                    itemBuilder:
                        (
                      context,
                      index,
                    ) {
                      final task =
                          tasks[index];

                      return TaskCard(
                        task: task,
                        onStatusChanged:
                            (
                          newStatus,
                        ) {
                          _changeTaskStatus(
                            task,
                            newStatus,
                          );
                        },
                        onDelete: () {
                          _deleteTask(
                            task,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState
    extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          24,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.noInternet,
              height: 120,
            ),
            const SizedBox(
              height: 18,
            ),
            Text(
              message,
              textAlign:
                  TextAlign.center,
            ),
            const SizedBox(
              height: 16,
            ),
            OutlinedButton(
              onPressed:
                  onRetry,
              child:
                  const Text(
                'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
