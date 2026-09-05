import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;
  final String? iconAsset;
  final Color accentColor;
  final bool isLoading;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.iconAsset,
    this.accentColor = AppColors.primary,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(19),
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
      padding: const EdgeInsets.all(13),
      child: Row(
        children: [
          if (iconAsset != null)
            SizedBox(
              width: 38,
              height: 38,
              child: SvgPicture.asset(
                iconAsset!,
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.2,
                fontWeight:
                    FontWeight.w700,
                color: accentColor,
              ),
            ),
          ),
          const SizedBox(width: 7),
          if (isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          else
            Column(
              mainAxisSize:
                  MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                Text(
                  value.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    height: 1,
                    fontWeight:
                        FontWeight.w800,
                    color:
                        AppColors.textPrimary,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value == 1
                      ? 'task'
                      : 'tasks',
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight:
                        FontWeight.w500,
                    color: AppColors
                        .textSecondary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
