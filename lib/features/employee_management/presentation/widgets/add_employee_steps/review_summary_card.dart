import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReviewSummaryCard extends StatelessWidget {
  const ReviewSummaryCard({
    super.key,
    required this.iconPath,
    required this.title,
    required this.rows,
    this.valueBold = false,
    this.valueColor,
  });

  final String iconPath;
  final String title;
  final List<ReviewSummaryRow> rows;
  final bool valueBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColorResolved = valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          Row(
            children: [
              DigifyAsset(assetPath: iconPath, width: 14.w, height: 14.h, color: AppColors.primary),
              Gap(7.w),
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  ),
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (rows.length == 2) {
                if (constraints.maxWidth > 520) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildRow(context, rows[0], labelColor, valueColorResolved)),
                      Gap(24.w),
                      Expanded(child: _buildRow(context, rows[1], labelColor, valueColorResolved)),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow(context, rows[0], labelColor, valueColorResolved),
                    Gap(10.w),
                    _buildRow(context, rows[1], labelColor, valueColorResolved),
                  ],
                );
              }
              final hasDivider = rows.any((r) => r.dividerBefore);
              final useTwoColumns = !hasDivider && constraints.maxWidth > 500 && rows.length > 2;
              if (useTwoColumns) {
                final half = (rows.length / 2).ceil();
                final left = rows.sublist(0, half);
                final right = rows.sublist(half);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.h,
                        children: _buildRowsWithDividers(context, left, labelColor, valueColorResolved),
                      ),
                    ),
                    Gap(14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10.h,
                        children: _buildRowsWithDividers(context, right, labelColor, valueColorResolved),
                      ),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10.h,
                children: _buildRowsWithDividers(context, rows, labelColor, valueColorResolved),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRowsWithDividers(
    BuildContext context,
    List<ReviewSummaryRow> rowList,
    Color labelColor,
    Color valueColorResolved,
  ) {
    final isDark = context.isDark;
    final dividerColor = isDark ? AppColors.borderGreyDark : AppColors.borderGrey;
    final list = <Widget>[];
    for (var i = 0; i < rowList.length; i++) {
      final r = rowList[i];
      if (r.dividerBefore && i > 0) {
        list.add(
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Divider(height: 1, color: dividerColor, thickness: 1),
          ),
        );
      }
      list.add(_buildRow(context, r, labelColor, valueColorResolved));
    }
    return list;
  }

  Widget _buildRow(BuildContext context, ReviewSummaryRow row, Color labelColor, Color valueColorResolved) {
    final useBold = row.valueBold ?? valueBold;
    final effectiveValueColor = useBold ? AppColors.primary : valueColorResolved;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 40,
          child: Text('${row.label}:', style: context.textTheme.labelSmall?.copyWith(color: labelColor)),
        ),
        Expanded(
          flex: 60,
          child: Text(
            row.value,
            style: context.textTheme.labelSmall?.copyWith(color: effectiveValueColor),
            textAlign: row.rightAlign ? TextAlign.end : TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class ReviewSummaryRow {
  const ReviewSummaryRow({
    required this.label,
    required this.value,
    this.valueBold,
    this.labelBold = false,
    this.rightAlign = false,
    this.dividerBefore = false,
  });

  final String label;
  final String value;
  final bool? valueBold;
  final bool labelBold;
  final bool rightAlign;
  final bool dividerBefore;
}
