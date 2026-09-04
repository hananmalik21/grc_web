import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardBackground extends StatelessWidget {
  final bool isDark;

  const DashboardBackground({super.key, required this.isDark});

  Widget _circle({required double width, required double height, required List<Color> colors}) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDark ? const Color(0xFF141414) : const Color(0xFFF3F6FA),
    );
  }
}
