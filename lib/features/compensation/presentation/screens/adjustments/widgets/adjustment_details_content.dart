import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustmentDetailsContent extends StatelessWidget {
  final AdjustmentRowData row;

  const AdjustmentDetailsContent({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _DetailSection(
          title: 'Employee Information',
          child: _FieldGrid(
            children: [
              _DetailField(label: 'Employee Name', value: row.employeeName),
              _DetailField(label: 'Employee Number', value: row.employeeId),
              _DetailField(label: 'Department', value: row.department),
            ],
          ),
        ),
        Gap(20.h),
        _DetailSection(
          title: 'Adjustment Details',
          child: _FieldGrid(
            children: [
              _DetailField(label: 'Adjustment Type', value: row.adjustmentType),
              _DetailField(label: 'Current Salary', value: row.currentSalary),
              _DetailField(label: 'Adjustment Method', value: row.adjustmentMethod),
              _DetailField(label: 'Adjustment Value', value: row.adjustmentValue),
              _DetailField(
                label: 'New Salary',
                value: row.newSalary,
                valueColor: AppColors.success,
                emphasized: true,
                large: true,
              ),
              _IncreaseSummaryTile(amount: row.increaseAmount, percentage: row.increasePercent),
            ],
          ),
        ),
        Gap(20.h),
        _DetailSection(
          title: 'Administrative Details',
          child: _FieldGrid(
            children: [
              _DetailField(label: 'Effective Date', value: row.effectiveDate),
              _CapsuleField(
                label: 'Reason Code',
                child: DigifyCapsule(
                  label: row.reasonCode,
                  backgroundColor: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                  textColor: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              _CapsuleField(
                label: 'Status',
                child: DigifyStatusCapsule(status: row.status.label),
              ),
              _DetailField(label: 'Submitted By', value: row.submittedBy),
              _DetailField(label: 'Submitted Date', value: row.submittedDate),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 18.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          DigifyDivider.horizontal(height: 1.h),
          Padding(padding: EdgeInsets.all(16.w), child: child),
        ],
      ),
    );
  }
}

class _FieldGrid extends StatelessWidget {
  final List<Widget> children;

  const _FieldGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 18.w;
        final isTwoColumns = constraints.maxWidth >= 560.w;
        final tileWidth = isTwoColumns ? (constraints.maxWidth - spacing) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: 22.h,
          children: [for (final child in children) SizedBox(width: tileWidth, child: child)],
        );
      },
    );
  }
}

class _DetailField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool emphasized;
  final bool large;

  const _DetailField({
    required this.label,
    required this.value,
    this.valueColor,
    this.emphasized = false,
    this.large = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(5.h),
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: 15.sp,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

class _CapsuleField extends StatelessWidget {
  final String label;
  final Widget child;

  const _CapsuleField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(5.h),
        child,
      ],
    );
  }
}

class _IncreaseSummaryTile extends StatelessWidget {
  final String amount;
  final String percentage;

  const _IncreaseSummaryTile({required this.amount, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : const Color(0xFFA5C1FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOTAL INCREASE', style: context.textTheme.labelMedium?.copyWith(color: AppColors.primary)),
          Gap(5.h),
          Text('$amount $percentage', style: context.textTheme.headlineMedium?.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
