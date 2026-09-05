import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../core/constants/task_status.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  final ValueChanged<String>
      onStatusChanged;

  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onStatusChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        _statusColor(task.status);

    return Card(
      margin:
          const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  padding:
                      const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        statusColor.withAlpha(24),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    _statusAsset(task.status),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w700,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        task.description,
                        style:
                            const TextStyle(
                          height: 1.4,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (task.createdDate != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_outlined,
                    size: 17,
                    color: AppColors
                        .textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(
                      task.createdDate!,
                    ),
                    style:
                        const TextStyle(
                      fontSize: 12,
                      color: AppColors
                          .textSecondary,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        statusColor.withAlpha(24),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  tooltip: 'Update task status',
                  onSelected:
                      onStatusChanged,
                  itemBuilder: (context) {
                    return TaskStatus.values
                        .where(
                          (status) =>
                              status !=
                              task.status,
                        )
                        .map(
                          (status) =>
                              PopupMenuItem<
                                  String>(
                            value: status,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      SvgPicture.asset(
                                    _statusAsset(
                                      status,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Move to $status',
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList();
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary
                            .withAlpha(70),
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        Icon(
                          Icons
                              .swap_horiz_rounded,
                          size: 18,
                          color:
                              AppColors.primary,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w700,
                            color:
                                AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: 'Delete task',
                  onPressed: onDelete,
                  icon: SvgPicture.asset(
                    AppAssets.delete,
                    width: 21,
                    height: 21,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _statusAsset(String status) {
    switch (status) {
      case TaskStatus.inProgress:
        return AppAssets.progressTask;
      case TaskStatus.completed:
        return AppAssets.completedTask;
      case TaskStatus.cancelled:
        return AppAssets.cancelledTask;
      case TaskStatus.newTask:
      default:
        return AppAssets.newTask;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case TaskStatus.inProgress:
        return Colors.orange.shade700;
      case TaskStatus.completed:
        return AppColors.success;
      case TaskStatus.cancelled:
        return AppColors.danger;
      case TaskStatus.newTask:
      default:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    final day =
        local.day.toString().padLeft(2, '0');

    final month =
        local.month.toString().padLeft(2, '0');

    final hour =
        local.hour.toString().padLeft(2, '0');

    final minute =
        local.minute.toString().padLeft(2, '0');

    return '$day/$month/${local.year}  '
        '$hour:$minute';
  }
}
