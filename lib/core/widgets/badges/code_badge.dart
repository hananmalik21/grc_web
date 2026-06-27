import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CodeBadge extends StatelessWidget {
  final String code;
  final Color? backgroundColor;
  final Color? textColor;

  const CodeBadge({super.key, required this.code, this.backgroundColor, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.workPatternBadgeBgLight,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        code,
        style: context.textTheme.labelSmall?.copyWith(color: textColor ?? AppColors.purpleTextSecondary),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
