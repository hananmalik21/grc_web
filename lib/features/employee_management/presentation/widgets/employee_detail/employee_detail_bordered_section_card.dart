import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeDetailBorderedField {
  const EmployeeDetailBorderedField({
    required this.label,
    required this.value,
    this.isValueRtl = false,
    this.dividerAbove = false,
    this.valueWidget,
  });

  final String label;
  final String value;
  final bool isValueRtl;
  final bool dividerAbove;
  final Widget? valueWidget;
}

class EmployeeDetailBorderedSectionCard extends StatelessWidget {
  const EmployeeDetailBorderedSectionCard({
    super.key,
    required this.title,
    this.titleIconAssetPath,
    required this.leftColumnFields,
    required this.rightColumnFields,
    required this.isDark,
  });

  final String title;
  final String? titleIconAssetPath;
  final List<EmployeeDetailBorderedField> leftColumnFields;
  final List<EmployeeDetailBorderedField> rightColumnFields;
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
      child: Padding(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildColumn(
                    context,
                    fields: leftColumnFields,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: borderColor,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: _buildColumn(
                    context,
                    fields: rightColumnFields,
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    borderColor: borderColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(
    BuildContext context, {
    required List<EmployeeDetailBorderedField> fields,
    required Color textPrimary,
    required Color textSecondary,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < fields.length; i++) ...[
          if (fields[i].dividerAbove) Divider(height: 1.h, thickness: 1, color: borderColor),
          _BorderedFieldRow(field: fields[i]),
          if (i < fields.length - 1) ...[Gap(12.h), Divider(height: 1.h, thickness: 1, color: borderColor), Gap(12.h)],
        ],
      ],
    );
  }
}

class _BorderedFieldRow extends StatelessWidget {
  const _BorderedFieldRow({required this.field});

  final EmployeeDetailBorderedField field;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(field.label, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
        Gap(4.h),
        field.valueWidget ??
            Text(
              field.value,
              style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
              textAlign: field.isValueRtl ? TextAlign.right : TextAlign.left,
            ),
      ],
    );
  }
}
