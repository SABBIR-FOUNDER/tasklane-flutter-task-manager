import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final String? iconAsset;
  final Color accentColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.iconAsset,
    this.accentColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (iconAsset != null) ...[
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accentColor.withAlpha(24),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  iconAsset!,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          AppColors.textSecondary,
                    ),
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
