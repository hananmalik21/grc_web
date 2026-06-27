import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailRowItem {
  const EmployeeDetailRowItem({required this.label, required this.value});

  final String label;
  final String value;
}

class EmployeeDetailRowSectionCard extends StatelessWidget {
  const EmployeeDetailRowSectionCard({
    super.key,
    required this.title,
    this.titleIconAssetPath,
    required this.rows,
    this.footer,
    required this.isDark,
  });

  final String title;
  final String? titleIconAssetPath;
  final List<EmployeeDetailRowItem> rows;
  final Widget? footer;
  final bool isDark;

  static const double _borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: _borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
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
                      Expanded(
                        child: Text(rows[i].label, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
                      ),
                      Text(
                        rows[i].value,
                        style: context.textTheme.titleSmall?.copyWith(color: textPrimary, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  if (i < rows.length - 1) ...[Gap(12.h), DigifyDivider.horizontal(color: borderColor), Gap(12.h)],
                ],
              ],
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}
