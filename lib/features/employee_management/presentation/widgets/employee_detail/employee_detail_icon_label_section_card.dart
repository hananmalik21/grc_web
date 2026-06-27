import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailIconLabelRow {
  const EmployeeDetailIconLabelRow({required this.iconPath, required this.label, required this.value});

  final String iconPath;
  final String label;
  final String value;
}

class EmployeeDetailIconLabelSectionCard extends StatelessWidget {
  const EmployeeDetailIconLabelSectionCard({
    super.key,
    required this.title,
    this.titleIconAssetPath,
    required this.rows,
    this.isDark = false,
    this.borderColor,
  });

  final String title;
  final String? titleIconAssetPath;
  final List<EmployeeDetailIconLabelRow> rows;
  final bool isDark;
  final Color? borderColor;

  static const double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final iconColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final effectiveBorderColor = borderColor ?? (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: effectiveBorderColor, width: _borderWidth),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DigifyAsset(
                  assetPath: titleIconAssetPath ?? Assets.icons.leaveManagement.myLeave.path,
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.primary,
                ),
                Gap(8.w),
                Text(title, style: context.textTheme.titleMedium?.copyWith(color: textPrimary)),
              ],
            ),
            Gap(28.h),
            for (var i = 0; i < rows.length; i++) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DigifyAsset(assetPath: rows[i].iconPath, width: 20.w, height: 20.h, color: iconColor),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(rows[i].label, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                        Gap(4.h),
                        Text(
                          rows[i].value,
                          style: context.textTheme.titleSmall?.copyWith(color: textPrimary, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (i < rows.length - 1) ...[
                Gap(12.h),
                Divider(height: 1.h, thickness: 1, color: effectiveBorderColor),
                Gap(12.h),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
