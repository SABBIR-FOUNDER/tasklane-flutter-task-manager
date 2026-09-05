import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/app_colors.dart';
import '../../core/constants/task_status.dart';
import '../../models/task_model.dart';
import '../../providers/profile_provider.dart';
import '../../providers/task_provider.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/task_card.dart';
import '../task/create_task_screen.dart';
import '../task/task_list_screen.dart';

class DashboardScreen
    extends StatefulWidget {
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

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (mounted) {
        _loadDashboard();
      }
    });
  }

  Future<void> _loadDashboard() async {
    final profileProvider =
        context.read<ProfileProvider>();

    final taskProvider =
        context.read<TaskProvider>();

    await Future.wait([
      profileProvider.loadProfile(),
      taskProvider.loadTasks(
        TaskStatus.newTask,
      ),
      taskProvider.loadTaskCount(),
    ]);
  }

  Future<void> _openCreateTask() async {
    final created =
        await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const CreateTaskScreen(),
      ),
    );

    if (created == true && mounted) {
      await _loadDashboard();
    }
  }

  void _openStatus(
    String status,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            TaskListScreen(
          status: status,
        ),
      ),
    );
  }

  Future<void> _changeStatus(
    TaskModel task,
    String newStatus,
  ) async {
    final provider =
        context.read<TaskProvider>();

    final success =
        await provider.updateTaskStatus(
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
      builder: (dialogContext) {
        return AlertDialog(
          title:
              const Text('Delete task?'),
          content: Text(
            'Delete "${task.title}"?',
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
                  const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text('Delete'),
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
            const Text('TaskLane'),
      ),
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: _openCreateTask,
        icon: SvgPicture.asset(
          AppAssets.addTask,
          width: 22,
          height: 22,
        ),
        label:
            const Text('New Task'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: Consumer2<
            ProfileProvider,
            TaskProvider>(
          builder: (
            context,
            profileProvider,
            taskProvider,
            child,
          ) {
            final newTasks =
                taskProvider.tasksFor(
              TaskStatus.newTask,
            );

            final newTasksError =
                taskProvider.errorFor(
              TaskStatus.newTask,
            );

            final count =
                taskProvider.count;

            return ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.all(20),
              children: [
                DashboardHeader(
                  name: profileProvider
                          .profile
                          ?.firstName ??
                      'User',
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Task Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w700,
                    color: AppColors
                        .textPrimary,
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
                GridView.count(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.55,
                  children: [
                    _statusCard(
                      title: 'New',
                      value:
                          count?.newTask ??
                              0,
                      status:
                          TaskStatus.newTask,
                      iconAsset:
                          AppAssets.newTask,
                      accentColor:
                          AppColors.primary,
                    ),
                    _statusCard(
                      title: 'In Progress',
                      value: count
                              ?.inProgressTask ??
                          0,
                      status: TaskStatus
                          .inProgress,
                      iconAsset: AppAssets
                          .progressTask,
                      accentColor:
                          Colors.orange,
                    ),
                    _statusCard(
                      title: 'Completed',
                      value: count
                              ?.completedTask ??
                          0,
                      status: TaskStatus
                          .completed,
                      iconAsset: AppAssets
                          .completedTask,
                      accentColor:
                          AppColors.success,
                    ),
                    _statusCard(
                      title: 'Cancelled',
                      value: count
                              ?.cancelledTask ??
                          0,
                      status: TaskStatus
                          .cancelled,
                      iconAsset: AppAssets
                          .cancelledTask,
                      accentColor:
                          AppColors.danger,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'New Tasks',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight:
                              FontWeight.w700,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _openStatus(
                          TaskStatus
                              .newTask,
                        );
                      },
                      child:
                          const Text(
                        'View All',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                if (taskProvider
                        .isLoadingStatus(
                      TaskStatus.newTask,
                    ) &&
                    newTasks.isEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    child: Center(
                      child:
                          CircularProgressIndicator(),
                    ),
                  )
                else if (newTasksError !=
                        null &&
                    newTasks.isEmpty)
                  _dashboardMessage(
                    icon:
                        AppAssets.noInternet,
                    title:
                        'Unable to load tasks',
                    message:
                        newTasksError,
                  )
                else if (newTasks.isEmpty)
                  _dashboardMessage(
                    icon:
                        AppAssets.emptyTasks,
                    title: 'No new tasks',
                    message:
                        'Create a task and it will appear here.',
                  )
                else
                  ...newTasks
                      .take(5)
                      .map(
                    (task) {
                      return TaskCard(
                        task: task,
                        onStatusChanged:
                            (newStatus) {
                          _changeStatus(
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
                const SizedBox(
                  height: 90,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _statusCard({
    required String title,
    required int value,
    required String status,
    required String iconAsset,
    required Color accentColor,
  }) {
    return InkWell(
      borderRadius:
          BorderRadius.circular(12),
      onTap: () {
        _openStatus(status);
      },
      child: StatCard(
        title: title,
        value: value,
        iconAsset: iconAsset,
        accentColor: accentColor,
      ),
    );
  }

  Widget _dashboardMessage({
    required String icon,
    required String title,
    required String message,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 36,
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            height: 110,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w600,
              color: AppColors
                  .textPrimary,
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            message,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
