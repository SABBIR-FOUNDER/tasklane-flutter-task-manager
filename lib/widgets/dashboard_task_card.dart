import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';
import '../models/task_model.dart';

class DashboardTaskCard
    extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;

  const DashboardTaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08111827),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
              BorderRadius.circular(18),
          child: Padding(
            padding:
                const EdgeInsets.all(13),
            child: Row(
              children: [
                SizedBox(
                  width: 42,
                  height: 42,
                  child:
                      SvgPicture.asset(
                    AppAssets.newTask,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 14,
                          fontWeight:
                              FontWeight
                                  .w800,
                          color: AppColors
                              .textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          fontSize: 11.5,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                      if (task.createdDate !=
                          null) ...[
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AppAssets.calendar,
                              width: 13,
                              height: 13,
                              colorFilter:
                                  const ColorFilter
                                      .mode(
                                AppColors
                                    .textSecondary,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              _formatDate(
                                task.createdDate!,
                              ),
                              style:
                                  const TextStyle(
                                fontSize: 9.8,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 30,
                  height: 30,
                  alignment:
                      Alignment.center,
                  decoration:
                      BoxDecoration(
                    color:
                        AppColors.purpleSoft,
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                  child:
                      SvgPicture.asset(
                    AppAssets.chevronRight,
                    width: 15,
                    height: 15,
                    colorFilter:
                        const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
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

  String _formatDate(
    DateTime date,
  ) {
    final local = date.toLocal();

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

    return '${months[local.month - 1]} '
        '${local.day}, ${local.year}';
  }
}
