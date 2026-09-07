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
import '../../providers/task_timer_provider.dart';
import '../task/create_task_screen.dart';
import '../task/task_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onCreateTask;
  final ValueChanged<String>? onOpenTasks;

  const DashboardScreen({
    super.key,
    this.onCreateTask,
    this.onOpenTasks,
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
      taskProvider.loadTaskCount(),
      taskProvider.loadTasks(
        TaskStatus.newTask,
      ),
      taskProvider.loadTasks(
        TaskStatus.inProgress,
      ),
      taskProvider.loadTasks(
        TaskStatus.completed,
      ),
      taskProvider.loadTasks(
        TaskStatus.cancelled,
      ),
    ]);

  }

  Future<void> _openCreateTask() async {
    if (widget.onCreateTask != null) {
      widget.onCreateTask!();
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const CreateTaskScreen(),
      ),
    );
  }

  void _openStatus(
    String status,
  ) {
    if (widget.onOpenTasks != null) {
      widget.onOpenTasks!(
        status,
      );
      return;
    }

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
              ? 'Task updated to $newStatus'
              : provider.error ??
                  'Unable to update task',
        ),
      ),
    );

    if (success) {
      _loadDashboard();
    }
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
          title: const Text(
            'Delete task?',
          ),
          content: Text(
            '"${task.title}" will be permanently removed.',
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
              style:
                  TextButton.styleFrom(
                foregroundColor:
                    AppColors.danger,
              ),
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

    if (!mounted) {
      return;
    }

    if (success) {
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

    if (success) {
      _loadDashboard();
    }
  }

  List<TaskModel> _allTasks(
    TaskProvider provider,
  ) {
    final tasks = <TaskModel>[
      ...provider.tasksFor(
        TaskStatus.newTask,
      ),
      ...provider.tasksFor(
        TaskStatus.inProgress,
      ),
      ...provider.tasksFor(
        TaskStatus.completed,
      ),
      ...provider.tasksFor(
        TaskStatus.cancelled,
      ),
    ];

    tasks.sort(
      (a, b) => _sortDate(
        b,
      ).compareTo(
        _sortDate(a),
      ),
    );

    return tasks;
  }

  DateTime _sortDate(
    TaskModel task,
  ) {
    return task.createdDate ??
        DateTime.fromMillisecondsSinceEpoch(
          0,
        );
  }

  String? _firstDashboardError(
    TaskProvider provider,
  ) {
    return provider.errorFor(
          TaskStatus.newTask,
        ) ??
        provider.errorFor(
          TaskStatus.inProgress,
        ) ??
        provider.errorFor(
          TaskStatus.completed,
        ) ??
        provider.errorFor(
          TaskStatus.cancelled,
        );
  }

  bool _isLoadingAny(
    TaskProvider provider,
  ) {
    return provider.isLoadingStatus(
          TaskStatus.newTask,
        ) ||
        provider.isLoadingStatus(
          TaskStatus.inProgress,
        ) ||
        provider.isLoadingStatus(
          TaskStatus.completed,
        ) ||
        provider.isLoadingStatus(
          TaskStatus.cancelled,
        );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
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
              final count =
                  taskProvider.count;

              final totalTasks =
                  (count?.newTask ?? 0) +
                      (count?.inProgressTask ??
                          0) +
                      (count?.completedTask ??
                          0) +
                      (count?.cancelledTask ??
                          0);

              final activeTasks =
                  (count?.newTask ?? 0) +
                      (count?.inProgressTask ??
                          0);

              final allTasks =
                  _allTasks(
                taskProvider,
              );

              final dashboardError =
                  _firstDashboardError(
                taskProvider,
              );

              return ListView(
                physics:
                    const AlwaysScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.fromLTRB(
                  14,
                  12,
                  14,
                  24,
                ),
                children: [
                  DashboardHeader(
                    name: profileProvider
                            .profile
                            ?.firstName ??
                        'there',
                    totalTasks:
                        totalTasks,
                    activeTasks:
                        activeTasks,
                    onCreateTask:
                        _openCreateTask,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const _SectionHeading(
                    title:
                        'Task overview',
                    subtitle:
                        'Your workflow at a glance',
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.72,
                    children: [
                      _statusCard(
                        title: 'New',
                        value:
                            count?.newTask ??
                                0,
                        status:
                            TaskStatus
                                .newTask,
                        iconAsset:
                            AppAssets
                                .newTask,
                        accentColor:
                            AppColors
                                .newTask,
                        isLoading:
                            taskProvider
                                .isCountLoading,
                      ),
                      _statusCard(
                        title:
                            'In Progress',
                        value: count
                                ?.inProgressTask ??
                            0,
                        status:
                            TaskStatus
                                .inProgress,
                        iconAsset:
                            AppAssets
                                .progressTask,
                        accentColor:
                            AppColors
                                .progress,
                        isLoading:
                            taskProvider
                                .isCountLoading,
                      ),
                      _statusCard(
                        title:
                            'Completed',
                        value: count
                                ?.completedTask ??
                            0,
                        status:
                            TaskStatus
                                .completed,
                        iconAsset:
                            AppAssets
                                .completedTask,
                        accentColor:
                            AppColors
                                .success,
                        isLoading:
                            taskProvider
                                .isCountLoading,
                      ),
                      _statusCard(
                        title:
                            'Cancelled',
                        value: count
                                ?.cancelledTask ??
                            0,
                        status:
                            TaskStatus
                                .cancelled,
                        iconAsset:
                            AppAssets
                                .cancelledTask,
                        accentColor:
                            AppColors
                                .danger,
                        isLoading:
                            taskProvider
                                .isCountLoading,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,
                    children: [
                      const Expanded(
                        child:
                            _SectionHeading(
                          title:
                              'All tasks',
                          subtitle:
                              'Showing the latest added tasks first',
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
                          'Manage',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_isLoadingAny(
                        taskProvider,
                      ) &&
                      allTasks.isEmpty)
                    const _DashboardLoading()
                  else if (dashboardError !=
                          null &&
                      allTasks.isEmpty)
                    _DashboardMessage(
                      icon:
                          AppAssets
                              .noInternet,
                      title:
                          'Could not load tasks',
                      message:
                          dashboardError,
                      actionLabel:
                          'Try again',
                      onAction:
                          _loadDashboard,
                    )
                  else if (allTasks.isEmpty)
                    _DashboardMessage(
                      icon:
                          AppAssets
                              .emptyTasks,
                      title:
                          'Your lane is clear',
                      message:
                          'Create a new task and it will appear here.',
                      actionLabel:
                          'Create task',
                      onAction:
                          _openCreateTask,
                    )
                  else
                    ...allTasks.map(
                      (task) =>
                          TaskCard(
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
                      ),
                    ),
                ],
              );
            },
          ),
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
    required bool isLoading,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          19,
        ),
        onTap: () {
          _openStatus(
            status,
          );
        },
        child: StatCard(
          title: title,
          value: value,
          iconAsset:
              iconAsset,
          accentColor:
              accentColor,
          isLoading:
              isLoading,
        ),
      ),
    );
  }
}

class _SectionHeading
    extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(
            fontSize: 19,
            fontWeight:
                FontWeight.w800,
            color:
                AppColors.textPrimary,
            letterSpacing:
                -0.25,
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          subtitle,
          style:
              const TextStyle(
            fontSize: 11.5,
            color:
                AppColors
                    .textSecondary,
          ),
        ),
      ],
    );
  }
}

class _DashboardLoading
    extends StatelessWidget {
  const _DashboardLoading();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: 92,
      alignment:
          Alignment.center,
      decoration:
          BoxDecoration(
        color:
            AppColors.card,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              AppColors.border,
        ),
      ),
      child:
          const CircularProgressIndicator(),
    );
  }
}

class _DashboardMessage
    extends StatelessWidget {
  final String icon;
  final String title;
  final String message;
  final String actionLabel;
  final Future<void> Function()
      onAction;

  const _DashboardMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        18,
      ),
      decoration:
          BoxDecoration(
        color:
            AppColors.card,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border:
            Border.all(
          color:
              AppColors.border,
        ),
      ),
      child: Column(
        children: [
          SvgPicture.asset(
            icon,
            height: 88,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            title,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w800,
              color:
                  AppColors
                      .textPrimary,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            message,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              fontSize: 12,
              height: 1.4,
              color:
                  AppColors
                      .textSecondary,
            ),
          ),
          const SizedBox(
            height: 13,
          ),
          OutlinedButton(
            onPressed: () {
              onAction();
            },
            child:
                Text(
              actionLabel,
            ),
          ),
        ],
      ),
    );
  }
}
