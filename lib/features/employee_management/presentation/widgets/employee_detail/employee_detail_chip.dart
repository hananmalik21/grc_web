import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailChip extends StatelessWidget {
  const EmployeeDetailChip({super.key, required this.path, required this.label, required this.isDark});

  final String path;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final color = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAsset(assetPath: path, color: AppColors.primary, width: 16.w, height: 16.w),
        Gap(4.w),
        Flexible(
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(color: color),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
