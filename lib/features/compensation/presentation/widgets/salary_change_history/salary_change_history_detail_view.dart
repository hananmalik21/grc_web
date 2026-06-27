import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_config.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum SalaryChangeHistoryDetailLayout { desktop, mobile }

class SalaryChangeHistoryDetailView extends StatelessWidget {
  const SalaryChangeHistoryDetailView({super.key, required this.row, required this.layout});

  final SalaryChangeHistoryTableRowData row;
  final SalaryChangeHistoryDetailLayout layout;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isDesktop = layout == SalaryChangeHistoryDetailLayout.desktop;
    final sectionGap = isDesktop ? 24.h : 16.h;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 24.w : 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionCard(
            title: 'Employee Information',
            isDark: isDark,
            child: _EmployeeInfoContent(row: row, isDesktop: isDesktop),
          ),
          Gap(sectionGap),
          _SectionCard(
            title: 'Change Details',
            isDark: isDark,
            child: _ChangeDetailsContent(row: row, isDesktop: isDesktop),
          ),
          Gap(sectionGap),
          _SectionCard(
            title: 'Compensation Changes',
            isDark: isDark,
            child: _CompensationChangesContent(row: row, isDesktop: isDesktop),
          ),
          Gap(sectionGap),
          _SectionCard(
            title: 'Component-Level Changes',
            isDark: isDark,
            child: _ComponentChangesContent(row: row, isDesktop: isDesktop),
          ),
          Gap(sectionGap),
          _TotalImpactBanner(row: row),
          Gap(sectionGap),
          _SectionCard(
            title: 'Reason',
            isDark: isDark,
            child: _ReasonContent(isDark: isDark),
          ),
          Gap(sectionGap),
          _SectionCard(
            title: 'Approval Workflow',
            isDark: isDark,
            child: _ApprovalWorkflowContent(isDark: isDark),
          ),
          Gap(sectionGap),
          _SectionCard(
            title: 'Comments',
            isDark: isDark,
            child: _CommentsContent(isDark: isDark),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Section content widgets
// ---------------------------------------------------------------------------

class _EmployeeInfoContent extends StatelessWidget {
  const _EmployeeInfoContent({required this.row, required this.isDesktop});

  final SalaryChangeHistoryTableRowData row;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return _InfoGrid(
      isDesktop: isDesktop,
      columnCount: 2,
      items: [
        _InfoItem(label: 'Employee Name', value: row.employeeName),
        _InfoItem(label: 'Employee ID', value: row.employeeId),
        _InfoItem(label: 'Department', value: row.department),
        _InfoItem(label: 'Position', value: row.jobTitle),
        _InfoItem(label: 'Grade', value: row.gradeName),
      ],
    );
  }
}

class _ChangeDetailsContent extends StatelessWidget {
  const _ChangeDetailsContent({required this.row, required this.isDesktop});

  final SalaryChangeHistoryTableRowData row;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return _InfoGrid(
      isDesktop: isDesktop,
      columnCount: 2,
      items: [
        _InfoItem(label: 'Change Type', value: row.changeType, capsule: true),
        _InfoItem(label: 'Status', value: row.status, statusCapsule: true),
        _InfoItem(label: 'Effective Date', value: row.effectiveDate),
        _InfoItem(label: 'Submission Date', value: SalaryChangeHistoryConfig.placeholderSubmissionDate),
      ],
    );
  }
}

class _CompensationChangesContent extends StatelessWidget {
  const _CompensationChangesContent({required this.row, required this.isDesktop});

  final SalaryChangeHistoryTableRowData row;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final differenceAmount = _ensureSignedValue(row.changeAmountLabel);
    final differencePercent = _ensureSignedValue(row.changePercentLabel);

    return _CompensationSummaryCard(
      isDesktop: isDesktop,
      previousSalary: row.previousSalaryLabel,
      newSalary: row.newSalaryLabel,
      differenceAmount: differenceAmount,
      differencePercent: differencePercent,
      isIncrease: row.isIncrease,
      isDecrease: row.isDecrease,
    );
  }
}

class _ComponentChangesContent extends StatelessWidget {
  const _ComponentChangesContent({required this.row, required this.isDesktop});

  final SalaryChangeHistoryTableRowData row;
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    final components = <_ComponentData>[
      _ComponentData(
        name: 'Base Salary',
        prev: row.previousSalaryLabel,
        current: row.newSalaryLabel,
        change: row.changeAmountLabel,
        percent: row.changePercentLabel,
        status: 'Modified',
        statusColor: AppColors.warning,
      ),
      ...SalaryChangeHistoryConfig.staticComponentTemplates.map(
        (template) => _ComponentData(
          name: template.name,
          prev: template.previousValue,
          current: template.currentValue,
          change: template.changeValue,
          percent: template.changePercent,
          status: template.status,
          statusColor: _resolveStatusColor(template.statusColorKey),
        ),
      ),
    ];

    return Column(
      children: [
        for (final comp in components)
          Container(
            margin: EdgeInsets.only(bottom: isDesktop ? 12.h : 8.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.websiteIcon.path,
                      width: 16.w,
                      height: 16.w,
                      color: AppColors.primary,
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Text(
                        comp.name,
                        style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    DigifyCapsule(
                      label: comp.status,
                      backgroundColor: comp.statusColor.withValues(alpha: 0.15),
                      textColor: comp.statusColor,
                    ),
                  ],
                ),
                Gap(12.h),
                isDesktop
                    ? Row(
                        children: [
                          _ComponentField(
                            label: 'Previous',
                            value: comp.prev,
                            labelColor: labelColor,
                            valueColor: valueColor,
                            isStrikethrough: comp.status != SalaryChangeHistoryConfig.unchangedStatus,
                            expand: true,
                          ),
                          _ComponentField(
                            label: 'Current',
                            value: comp.current,
                            labelColor: labelColor,
                            valueColor: valueColor,
                            isBold: true,
                            expand: true,
                          ),
                          _ComponentField(
                            label: 'Change Amount',
                            value: comp.change,
                            labelColor: labelColor,
                            valueColor: comp.change == SalaryChangeHistoryConfig.unchangedValue
                                ? labelColor
                                : valueColor,
                            expand: true,
                          ),
                          _ComponentField(
                            label: 'Change %',
                            value: comp.percent,
                            labelColor: labelColor,
                            valueColor: valueColor,
                            expand: true,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ComponentField(
                            label: 'Previous',
                            value: comp.prev,
                            labelColor: labelColor,
                            valueColor: valueColor,
                            isStrikethrough: comp.status != SalaryChangeHistoryConfig.unchangedStatus,
                            expand: false,
                          ),
                          Gap(8.h),
                          _ComponentField(
                            label: 'Current',
                            value: comp.current,
                            labelColor: labelColor,
                            valueColor: valueColor,
                            isBold: true,
                            expand: false,
                          ),
                          Gap(8.h),
                          _ComponentField(
                            label: 'Change Amount',
                            value: comp.change,
                            labelColor: labelColor,
                            valueColor: comp.change == SalaryChangeHistoryConfig.unchangedValue
                                ? labelColor
                                : valueColor,
                            expand: false,
                          ),
                          Gap(8.h),
                          _ComponentField(
                            label: 'Change %',
                            value: comp.percent,
                            labelColor: labelColor,
                            valueColor: valueColor,
                            expand: false,
                          ),
                        ],
                      ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TotalImpactBanner extends StatelessWidget {
  const _TotalImpactBanner({required this.row});

  final SalaryChangeHistoryTableRowData row;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total Compensation Impact', style: context.textTheme.titleMedium?.copyWith(fontSize: 14.sp)),
          Gap(8.h),
          Text(
            '${row.changeAmountLabel} (${row.changePercentLabel})',
            style: context.textTheme.headlineMedium?.copyWith(
              color: row.isIncrease ? AppColors.success : (row.isDecrease ? AppColors.warning : AppColors.primary),
              fontSize: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonContent extends StatelessWidget {
  const _ReasonContent({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Text(
        SalaryChangeHistoryConfig.reasonNote,
        style: context.textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
      ),
    );
  }
}

class _CommentsContent extends StatelessWidget {
  const _CommentsContent({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Text(
        SalaryChangeHistoryConfig.reviewerComment,
        style: context.textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
      ),
    );
  }
}

class _ApprovalWorkflowContent extends StatelessWidget {
  const _ApprovalWorkflowContent({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      children: [
        for (final approver in SalaryChangeHistoryConfig.mockApprovers)
          Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyAsset(assetPath: approver.assetPath, width: 20.w, height: 20.h, color: AppColors.primary),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(approver.status, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                        '${approver.name} - ${approver.title}',
                        style: context.textTheme.bodySmall?.copyWith(color: subTextColor),
                      ),
                      Text(approver.date, style: context.textTheme.bodySmall?.copyWith(color: subTextColor)),
                    ],
                  ),
                ),
                if (approver.status != 'Initiated By') const DigifyStatusCapsule(status: 'Approved'),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared layout widgets
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.isDark, required this.child});

  final String title;
  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Text(
              title,
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 14.sp,
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

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.isDesktop, required this.columnCount, required this.items});

  final bool isDesktop;
  final int columnCount;
  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    if (!isDesktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: EdgeInsets.only(bottom: item != items.last ? 12.h : 0),
            child: _buildField(context, item, labelColor, valueColor, isDark),
          );
        }).toList(),
      );
    }

    final crossAxisSpacing = 24.w;
    final mainAxisSpacing = 20.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - (crossAxisSpacing * (columnCount - 1))) / columnCount;

        return Wrap(
          spacing: crossAxisSpacing,
          runSpacing: mainAxisSpacing,
          children: [
            for (final item in items)
              SizedBox(width: tileWidth, child: _buildField(context, item, labelColor, valueColor, isDark)),
          ],
        );
      },
    );
  }

  Widget _buildField(BuildContext context, _InfoItem item, Color labelColor, Color valueColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label.toUpperCase(),
          style: context.textTheme.labelSmall?.copyWith(color: labelColor, fontSize: 12.sp),
        ),
        Gap(4.h),
        if (item.statusCapsule)
          DigifyStatusCapsule(status: item.value)
        else if (item.capsule)
          DigifyCapsule(
            label: item.value,
            backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
            textColor: labelColor,
          )
        else
          Text(item.value, style: context.textTheme.titleSmall?.copyWith(color: valueColor)),
      ],
    );
  }
}

class _ComponentField extends StatelessWidget {
  const _ComponentField({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    this.isBold = false,
    this.isStrikethrough = false,
    this.expand = true,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final bool isBold;
  final bool isStrikethrough;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: labelColor, fontWeight: FontWeight.w500),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            color: isStrikethrough ? labelColor : valueColor,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
            decorationColor: labelColor,
          ),
        ),
      ],
    );

    if (!expand) {
      return content;
    }

    return Expanded(child: content);
  }
}

class _CompensationSummaryCard extends StatelessWidget {
  const _CompensationSummaryCard({
    required this.isDesktop,
    required this.previousSalary,
    required this.newSalary,
    required this.differenceAmount,
    required this.differencePercent,
    required this.isIncrease,
    required this.isDecrease,
  });

  final bool isDesktop;
  final String previousSalary;
  final String newSalary;
  final String differenceAmount;
  final String differencePercent;
  final bool isIncrease;
  final bool isDecrease;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 22.w : 14.w, vertical: isDesktop ? 18.h : 14.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _CompensationMetricItem(
                    label: 'Previous Salary',
                    value: previousSalary,
                    valueColor: valueColor,
                  ),
                ),
                Expanded(
                  child: _CompensationMetricItem(label: 'New Salary', value: newSalary, valueColor: AppColors.primary),
                ),
                Expanded(
                  child: _CompensationMetricItem(
                    label: 'Difference',
                    value: differenceAmount,
                    valueColor: isIncrease ? AppColors.success : (isDecrease ? AppColors.warning : AppColors.primary),
                    subValue: differencePercent,
                    subValueColor: isIncrease
                        ? AppColors.success
                        : (isDecrease ? AppColors.warning : AppColors.primary),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _CompensationMetricItem(
                        label: 'Previous Salary',
                        value: previousSalary,
                        valueColor: valueColor,
                        isCompact: true,
                      ),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: _CompensationMetricItem(
                        label: 'New Salary',
                        value: newSalary,
                        valueColor: AppColors.primary,
                        isCompact: true,
                      ),
                    ),
                  ],
                ),
                Gap(10.h),
                const DigifyDivider.horizontal(),
                Gap(10.h),
                _CompensationMetricItem(
                  label: 'Difference',
                  value: differenceAmount,
                  valueColor: isIncrease ? AppColors.success : (isDecrease ? AppColors.warning : AppColors.primary),
                  subValue: differencePercent,
                  subValueColor: isIncrease ? AppColors.success : (isDecrease ? AppColors.warning : AppColors.primary),
                  isCompact: true,
                ),
              ],
            ),
    );
  }
}

class _CompensationMetricItem extends StatelessWidget {
  const _CompensationMetricItem({
    required this.label,
    required this.value,
    required this.valueColor,
    this.subValue,
    this.subValueColor,
    this.isCompact = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final String? subValue;
  final Color? subValueColor;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.inactiveStatusText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: isCompact ? 11.sp : 12.sp, color: labelColor),
        ),
        Gap(6.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.titleLarge?.copyWith(color: valueColor, fontSize: isCompact ? 16.sp : null),
        ),
        if (subValue != null) ...[
          Gap(2.h),
          Text(
            subValue!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: isCompact ? 13.sp : 14.sp,
              color: subValueColor ?? valueColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class _InfoItem {
  _InfoItem({required this.label, required this.value, this.capsule = false, this.statusCapsule = false});

  final String label;
  final String value;
  final bool capsule;
  final bool statusCapsule;
}

class _ComponentData {
  _ComponentData({
    required this.name,
    required this.prev,
    required this.current,
    required this.change,
    required this.percent,
    required this.status,
    required this.statusColor,
  });

  final String name;
  final String prev;
  final String current;
  final String change;
  final String percent;
  final String status;
  final Color statusColor;
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

Color _resolveStatusColor(String colorKey) {
  return switch (colorKey) {
    'warning' => AppColors.warning,
    'info' => AppColors.info,
    'success' => AppColors.success,
    _ => AppColors.info,
  };
}

String _ensureSignedValue(String value) {
  if (value.startsWith('-')) return value;
  return value;
}
