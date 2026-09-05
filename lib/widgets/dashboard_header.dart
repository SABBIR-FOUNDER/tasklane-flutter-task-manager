import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final String name;
  final int totalTasks;
  final int activeTasks;
  final VoidCallback onCreateTask;

  const DashboardHeader({
    super.key,
    required this.name,
    required this.totalTasks,
    required this.activeTasks,
    required this.onCreateTask,
  });

  @override
  Widget build(BuildContext context) {
    final displayName =
        name.trim().isEmpty
            ? 'there'
            : name.trim();

    return Container(
      height: 198,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withValues(
              alpha: 0.16,
            ),
            blurRadius: 26,
            offset:
                const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(26),
        child: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                AppAssets.dashboardHeader,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                18,
                16,
                18,
                17,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    AppAssets.wordmarkDark,
                    width: 122,
                  ),
                  const Spacer(),
                  Text(
                    'Hello, $displayName 👋',
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w800,
                      letterSpacing: -0.45,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Make progress on what matters today.',
                    style: TextStyle(
                      color:
                          Color(0xFFECEBFF),
                      fontSize: 12.5,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white
                              .withValues(
                            alpha: 0.13,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(12),
                          border: Border.all(
                            color: Colors.white
                                .withValues(
                              alpha: 0.16,
                            ),
                          ),
                        ),
                        child: Text(
                          '$totalTasks tasks  •  '
                          '$activeTasks active',
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        height: 36,
                        child:
                            FilledButton.icon(
                          onPressed:
                              onCreateTask,
                          style: FilledButton
                              .styleFrom(
                            backgroundColor:
                                Colors.white,
                            foregroundColor:
                                AppColors.primary,
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 12,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.add_rounded,
                            size: 17,
                          ),
                          label:
                              const Text(
                            'New task',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
