import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_colors.dart';
import '../core/constants/task_status.dart';
import '../models/task_model.dart';
import '../providers/task_timer_provider.dart';
import 'task_timer_sheet.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final ValueChanged<String> onStatusChanged;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(
      task.status,
    );

    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(
          19,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x09111827),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(
        14,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child: Icon(
                  _statusIcon(
                    task.status,
                  ),
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      task.description,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              if (task.createdDate != null) ...[
                const Icon(
                  Icons.schedule_rounded,
                  size: 15,
                  color:
                      AppColors.textSecondary,
                ),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Text(
                    _formatDate(
                      task.createdDate!,
                    ),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                ),
              ] else
                const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
                child: Text(
                  task.status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          Selector<
              TaskTimerProvider,
              _TaskTimerCardState>(
            selector: (
              context,
              provider,
            ) {
              final current =
                  provider.timer;

              final active =
                  provider.isTimerForTask(
                task.id,
              );

              return _TaskTimerCardState(
                active: active,
                running:
                    active &&
                        (current?.isRunning ??
                            false),
                finished:
                    active &&
                        (current?.isFinished ??
                            false),
                display:
                    provider.displayForTask(
                  task.id,
                ),
              );
            },
            builder: (
              context,
              timerState,
              child,
            ) {
              if (!timerState.active) {
                return const SizedBox.shrink();
              }

              final accent =
                  timerState.finished
                      ? AppColors.progress
                      : AppColors.primary;

              return Container(
                margin: const EdgeInsets.only(
                  top: 10,
                ),
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(
                    alpha: 0.08,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      timerState.finished
                          ? Icons
                              .notifications_active_outlined
                          : timerState.running
                              ? Icons
                                  .timer_outlined
                              : Icons
                                  .pause_circle_outline_rounded,
                      size: 17,
                      color: accent,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    Text(
                      timerState.finished
                          ? "Time's up"
                          : timerState.running
                              ? 'Focus timer'
                              : 'Timer paused',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight:
                            FontWeight.w700,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      timerState.display,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            FontWeight.w800,
                        color: accent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(
            height: 11,
          ),
          Row(
            children: [
              Expanded(
                child: _TimerButton(
                  task: task,
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showUpdateSheet(
                      context,
                    );
                  },
                  style:
                      OutlinedButton.styleFrom(
                    minimumSize:
                        const Size(
                      0,
                      38,
                    ),
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 8,
                    ),
                    side: BorderSide(
                      color: AppColors.primary
                          .withValues(
                        alpha: 0.28,
                      ),
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons
                        .swap_horiz_rounded,
                    size: 16,
                  ),
                  label: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 7,
              ),
              IconButton(
                onPressed: onDelete,
                tooltip: 'Delete',
                style:
                    IconButton.styleFrom(
                  backgroundColor:
                      AppColors.dangerSoft,
                  foregroundColor:
                      AppColors.danger,
                  minimumSize:
                      const Size(
                    38,
                    38,
                  ),
                  maximumSize:
                      const Size(
                    38,
                    38,
                  ),
                ),
                icon: const Icon(
                  Icons
                      .delete_outline_rounded,
                  size: 19,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showUpdateSheet(
    BuildContext context,
  ) async {
    final selected =
        await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.card,
      showDragHandle: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(
            26,
          ),
        ),
      ),
      builder: (
        sheetContext,
      ) {
        final options = TaskStatus.values
            .where(
              (status) =>
                  status != task.status,
            )
            .toList();

        return SafeArea(
          top: false,
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(
              18,
              2,
              18,
              20,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Update task status',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.textPrimary,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Choose the new status for this task.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ...options.map(
                  (status) {
                    final color =
                        _statusColor(
                      status,
                    );

                    return Container(
                      margin:
                          const EdgeInsets.only(
                        bottom: 8,
                      ),
                      decoration:
                          BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                          16,
                        ),
                        color: color.withValues(
                          alpha: 0.08,
                        ),
                      ),
                      child: ListTile(
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration:
                              BoxDecoration(
                            color: color
                                .withValues(
                              alpha: 0.14,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                          child: Icon(
                            _statusIcon(
                              status,
                            ),
                            color: color,
                          ),
                        ),
                        title: Text(
                          status,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                        trailing: Icon(
                          Icons
                              .chevron_right_rounded,
                          color: color,
                        ),
                        onTap: () {
                          Navigator.pop(
                            sheetContext,
                            status,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      onStatusChanged(
        selected,
      );
    }
  }

  IconData _statusIcon(
    String status,
  ) {
    switch (status) {
      case TaskStatus.inProgress:
        return Icons
            .hourglass_top_rounded;
      case TaskStatus.completed:
        return Icons
            .check_circle_rounded;
      case TaskStatus.cancelled:
        return Icons.cancel_rounded;
      case TaskStatus.newTask:
      default:
        return Icons.add_task_rounded;
    }
  }

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case TaskStatus.inProgress:
        return AppColors.progress;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.cancelled:
        return AppColors.danger;
      case TaskStatus.newTask:
      default:
        return AppColors.newTask;
    }
  }

  String _formatDate(
    DateTime date,
  ) {
    final local =
        date.toLocal();

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour =
        local.hour == 0
            ? 12
            : local.hour > 12
                ? local.hour - 12
                : local.hour;

    final minute = local.minute
        .toString()
        .padLeft(
          2,
          '0',
        );

    final period =
        local.hour >= 12
            ? 'PM'
            : 'AM';

    return '${months[local.month - 1]} '
        '${local.day}, ${local.year}  •  '
        '$hour:$minute $period';
  }
}

class _TimerButton
    extends StatelessWidget {
  final TaskModel task;

  const _TimerButton({
    required this.task,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Selector<
        TaskTimerProvider,
        String>(
      selector: (
        context,
        provider,
      ) {
        return provider
                .isTimerForTask(
              task.id,
            )
            ? provider
                .displayForTask(
                  task.id,
                )
            : '';
      },
      builder: (
        context,
        display,
        child,
      ) {
        final active =
            display.isNotEmpty;

        return OutlinedButton.icon(
          onPressed: () {
            showTaskTimerSheet(
              context,
              task,
            );
          },
          style:
              OutlinedButton.styleFrom(
            minimumSize:
                const Size(
              0,
              38,
            ),
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 8,
            ),
            foregroundColor:
                active
                    ? AppColors.primary
                    : AppColors
                        .textSecondary,
            side: BorderSide(
              color: active
                  ? AppColors.primary
                      .withValues(
                    alpha: 0.30,
                  )
                  : AppColors.border,
            ),
            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
          ),
          icon: const Icon(
            Icons.timer_outlined,
            size: 16,
          ),
          label: Text(
            active
                ? display
                : 'Timer',
            maxLines: 1,
            overflow:
                TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}

class _TaskTimerCardState {
  final bool active;
  final bool running;
  final bool finished;
  final String display;

  const _TaskTimerCardState({
    required this.active,
    required this.running,
    required this.finished,
    required this.display,
  });

  @override
  bool operator ==(
    Object other,
  ) {
    return other is _TaskTimerCardState &&
        other.active == active &&
        other.running == running &&
        other.finished == finished &&
        other.display == display;
  }

  @override
  int get hashCode =>
      Object.hash(
        active,
        running,
        finished,
        display,
      );
}
