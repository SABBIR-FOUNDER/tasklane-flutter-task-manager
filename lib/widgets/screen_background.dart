import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/app_assets.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;

  const ScreenBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            AppAssets.authBackground,
            fit: BoxFit.cover,
          ),
        ),

        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}