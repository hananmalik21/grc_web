import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/forms/digify_select_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class AccrualSlab {
  final String years;
  final String method;
  final String basis;

  const AccrualSlab({
    required this.years,
    required this.method,
    required this.basis,
  });
}

class CalculationBreakdownRow {
  final String label;
  final String value;
  final bool isHighlight;
  final bool isTotal;
  final Color? valueColor;

  const CalculationBreakdownRow({
    required this.label,
    required this.value,
    this.isHighlight = false,
    this.isTotal = false,
    this.valueColor,
  });
}

class EndOfService extends ConsumerStatefulWidget {
  const EndOfService({super.key});

  @override
  ConsumerState<EndOfService> createState() => _EndOfServiceState();
}

class _EndOfServiceState extends ConsumerState<EndOfService> {
  final List<AccrualSlab> _slabs = [
    const AccrualSlab(
      years: '1-5 years',
      method: '21 days per year',
      basis: 'Basic Salary',
    ),
    const AccrualSlab(
      years: '5+ years',
      method: '30 days per year',
      basis: 'Basic Salary',
    ),
  ];

  final List<CalculationBreakdownRow> _breakdown = [
    const CalculationBreakdownRow(
      label: 'First 5 years @ 21 days/year',
      value: '5 years × 21 days = 105 days',
    ),
    const CalculationBreakdownRow(
      label: 'Remaining 2.5 years @ 30 days/year',
      value: '2.5 years × 30 days = 75 days',
    ),
    const CalculationBreakdownRow(
      label: 'Total accrued days',
      value: '180 days',
      isHighlight: true,
    ),
    const CalculationBreakdownRow(
      label: 'Unpaid leave deduction',
      value: '-15 days',
      valueColor: AppColors.warningText,
    ),
    const CalculationBreakdownRow(
      label: 'Net eligible days',
      value: '165 days',
      isHighlight: true,
    ),
    const CalculationBreakdownRow(
      label: 'Daily rate (1,200 KWD ÷ 30)',
      value: '40 KWD/day',
    ),
    const CalculationBreakdownRow(
      label: 'Gross gratuity (165 × 40)',
      value: '6,600 KWD',
      isHighlight: true,
    ),
    const CalculationBreakdownRow(
      label: 'Resignation penalty (100% - tenure > 5 years)',
      value: '0% (Full entitlement)',
      valueColor: AppColors.success,
    ),
    const CalculationBreakdownRow(
      label: 'Leave balance payout (20 days × 40)',
      value: '800 KWD',
    ),
    const CalculationBreakdownRow(
      label: 'Repatriation ticket allowance',
      value: '2,450 KWD',
    ),
    const CalculationBreakdownRow(
      label: 'Total End of Service Payout',
      value: '9,850 KWD',
      isTotal: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConfigurationCard(context),
          Gap(24.h),
          _buildEstimatedCalculationCard(context),
          Gap(24.h),
          _buildUnderstandingCard(context),
          Gap(24.h),
        ],
      ),
    );
  }

  Widget _buildConfigurationCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'End of Service Configuration',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              DigifyCapsule(
                label: 'Kuwait',
                backgroundColor: AppColors.infoBg,
                textColor: AppColors.info,
                borderColor: Colors.transparent,
              ),
            ],
          ),
          Gap(8.h),
          Text(
            'Configure gratuity/severance calculation rules, accrual slabs, resignation handling, and termination policies based on labor law requirements',
            style: context.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Gap(24.h),
          if (context.isMobile) ...[
            DigifySelectWithLabel<String>(
              label: 'RULE TYPE',
              items: const ['Gratuity (GCC Labor Law)'],
              itemLabelBuilder: (item) => item,
              value: 'Gratuity (GCC Labor Law)',
              onChanged: (val) {},
            ),
            Gap(24.h),
            DigifySelectWithLabel<String>(
              label: 'ELIGIBLE EMPLOYEE GROUP',
              items: const ['Expatriates Only'],
              itemLabelBuilder: (item) => item,
              value: 'Expatriates Only',
              onChanged: (val) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectWithLabel<String>(
                    label: 'RULE TYPE',
                    items: const ['Gratuity (GCC Labor Law)'],
                    itemLabelBuilder: (item) => item,
                    value: 'Gratuity (GCC Labor Law)',
                    onChanged: (val) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectWithLabel<String>(
                    label: 'ELIGIBLE EMPLOYEE GROUP',
                    items: const ['Expatriates Only'],
                    itemLabelBuilder: (item) => item,
                    value: 'Expatriates Only',
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ],
          Gap(24.h),
          _buildAccrualSlabSection(context),
          Gap(24.h),
          if (context.isMobile) ...[
            DigifySelectWithLabel<String>(
              label: 'RESIGNATION RULE HANDLING',
              items: const ['50% for years 1-3, 100% for 3+ years'],
              itemLabelBuilder: (item) => item,
              value: '50% for years 1-3, 100% for 3+ years',
              onChanged: (val) {},
            ),
            Gap(24.h),
            DigifySelectWithLabel<String>(
              label: 'TERMINATION FOR CAUSE',
              items: const ['No gratuity'],
              itemLabelBuilder: (item) => item,
              value: 'No gratuity',
              onChanged: (val) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifySelectWithLabel<String>(
                    label: 'RESIGNATION RULE HANDLING',
                    items: const ['50% for years 1-3, 100% for 3+ years'],
                    itemLabelBuilder: (item) => item,
                    value: '50% for years 1-3, 100% for 3+ years',
                    onChanged: (val) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectWithLabel<String>(
                    label: 'TERMINATION FOR CAUSE',
                    items: const ['No gratuity'],
                    itemLabelBuilder: (item) => item,
                    value: 'No gratuity',
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ],
          Gap(24.h),
          if (context.isMobile) ...[
            DigifyTextField(
              labelText: 'GRATUITY CAP',
              hintText: 'No cap or specify max amount',
            ),
            Gap(24.h),
            DigifySelectWithLabel<String>(
              label: 'UNPAID LEAVE DEDUCTION',
              items: const ['Deduct unpaid leave days'],
              itemLabelBuilder: (item) => item,
              value: 'Deduct unpaid leave days',
              onChanged: (val) {},
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    labelText: 'GRATUITY CAP',
                    hintText: 'No cap or specify max amount',
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifySelectWithLabel<String>(
                    label: 'UNPAID LEAVE DEDUCTION',
                    items: const ['Deduct unpaid leave days'],
                    itemLabelBuilder: (item) => item,
                    value: 'Deduct unpaid leave days',
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ],
          Gap(24.h),
          if (context.isMobile) ...[
            SizedBox(
              width: 300.w,
              child: DigifyCheckbox(
                label: 'LEAVE BALANCE PAYOUT ON EXIT',
                value: true,
                onChanged: (val) {},
              ),
            ),
            Gap(24.h),
            SizedBox(
              width: 300.w,
              child: DigifyCheckbox(
                label: 'REPATRIATION TICKET BENEFIT',
                value: true,
                onChanged: (val) {},
              ),
            ),
            Gap(24.h),
            SizedBox(
              width: 300.w,
              child: DigifyCheckbox(
                label: 'APPROVAL WORKFLOW REQUIRED',
                value: true,
                onChanged: (val) {},
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyCheckbox(
                    label: 'LEAVE BALANCE PAYOUT ON EXIT',
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyCheckbox(
                    label: 'REPATRIATION TICKET BENEFIT',
                    value: true,
                    onChanged: (val) {},
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyCheckbox(
                    label: 'APPROVAL WORKFLOW REQUIRED',
                    value: false,
                    onChanged: (val) {},
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAccrualSlabSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundGreyDark
            : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cardBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Accrual Slabs',
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(16.h),
          ..._slabs.map(
            (slab) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: context.isMobile
                  ? Column(
                      children: [
                        DigifyTextField(
                          labelText: 'FIRST SLAB YEARS',
                          initialValue: slab.years,
                          readOnly: true,
                        ),
                        Gap(16.h),
                        DigifyTextField(
                          labelText: 'ACCRUAL METHOD',
                          initialValue: slab.method,
                          readOnly: true,
                        ),
                        Gap(16.h),
                        DigifyTextField(
                          labelText: 'BASIS',
                          initialValue: slab.basis,
                          readOnly: true,
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: DigifyTextField(
                            labelText: 'FIRST SLAB YEARS',
                            initialValue: slab.years,
                            readOnly: true,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: DigifyTextField(
                            labelText: 'ACCRUAL METHOD',
                            initialValue: slab.method,
                            readOnly: true,
                          ),
                        ),
                        Gap(16.w),
                        Expanded(
                          child: DigifyTextField(
                            labelText: 'BASIS',
                            initialValue: slab.basis,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedCalculationCard(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        children: [
          _buildEstimatedHeader(context),
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                _buildMetricsRow(context),
                Gap(24.h),
                _buildBreakdownTable(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.calculate_outlined,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Estimated End of Service Example',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(4.h),
                Text(
                  'Real-time calculation preview based on configured rules',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(BuildContext context) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildMetricItem(
            context,
            'SERVICE YEARS',
            '7.5 years',
            'Total employment duration',
          ),
          Gap(16.h),
          _buildMetricItem(
            context,
            'FINAL BASIC SALARY',
            '1,200 KWD',
            'Calculation basis',
          ),
          Gap(16.h),
          _buildMetricItem(
            context,
            'UNPAID LEAVE DAYS',
            '15 days',
            'Will be deducted',
          ),
          Gap(16.h),
          _buildMetricItem(
            context,
            'TERMINATION REASON',
            'Resignation',
            '100% entitlement',
          ),
          Gap(16.h),
          _buildMetricItem(
            context,
            'ESTIMATED PAYOUT',
            '9,850 KWD',
            'Total amount',
            isProminent: true,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildMetricItem(
            context,
            'SERVICE YEARS',
            '7.5 years',
            'Total employment duration',
          ),
        ),
        Gap(16.w),
        Expanded(
          child: _buildMetricItem(
            context,
            'FINAL BASIC SALARY',
            '1,200 KWD',
            'Calculation basis',
          ),
        ),
        Gap(16.w),
        Expanded(
          child: _buildMetricItem(
            context,
            'UNPAID LEAVE DAYS',
            '15 days',
            'Will be deducted',
          ),
        ),
        Gap(16.w),
        Expanded(
          child: _buildMetricItem(
            context,
            'TERMINATION REASON',
            'Resignation',
            '100% entitlement',
          ),
        ),
        Gap(16.w),
        Expanded(
          child: _buildMetricItem(
            context,
            'ESTIMATED PAYOUT',
            '9,850 KWD',
            'Total amount',
            isProminent: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricItem(
    BuildContext context,
    String label,
    String value,
    String subtitle, {
    bool isProminent = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isProminent ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isProminent ? AppColors.primary : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: isProminent ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
          Gap(4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: isProminent ? Colors.white : AppColors.textPrimary,
            ),
          ),
          Gap(4.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10.sp,
              color: isProminent ? Colors.white70 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownTable(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: AppColors.primary,
                size: 16.sp,
              ),
              Gap(8.w),
              Text(
                'Step-by-Step Calculation Breakdown',
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gap(16.h),
          ..._breakdown.map((row) => _buildBreakdownRow(context, row)),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(BuildContext context, CalculationBreakdownRow row) {
    if (row.isTotal) {
      return Container(
        margin: EdgeInsets.only(top: 8.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: context.isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                row.label,
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Gap(16.w),
            Text(
              row.value,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  row.label,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: row.isHighlight
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              Gap(16.w),
              Text(
                row.value,
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:
                      row.valueColor ??
                      (row.isHighlight
                          ? AppColors.textPrimary
                          : AppColors.textSecondary),
                ),
              ),
            ],
          ),
          Gap(12.h),
          const Divider(height: 1, color: AppColors.cardBorder),
        ],
      ),
    );
  }

  Widget _buildUnderstandingCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.warningText,
                  size: 20.sp,
                ),
                Gap(8.w),
                Text(
                  'Understanding End of Service Calculations',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: context.isMobile
                ? Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Key Concepts',
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(12.h),
                          _buildInfoPoint(
                            Icons.check_circle_outline,
                            'Accrual Slabs',
                            'Different rates apply based on service duration',
                          ),
                          _buildInfoPoint(
                            Icons.check_circle_outline,
                            'Basis',
                            'Component used for calculation (usually basic salary)',
                          ),
                          _buildInfoPoint(
                            Icons.check_circle_outline,
                            'Resignation Penalty',
                            'Reduced entitlement for voluntary resignation',
                          ),
                          _buildInfoPoint(
                            Icons.check_circle_outline,
                            'Daily Rate',
                            'Monthly salary divided by 30 days',
                          ),
                        ],
                      ),
                      Gap(24.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GCC Standard Practice',
                            style: context.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gap(12.h),
                          _buildInfoPoint(
                            Icons.trending_up,
                            'First 5 years',
                            '21 days per year of service',
                          ),
                          _buildInfoPoint(
                            Icons.trending_up,
                            'After 5 years',
                            '30 days per year of service',
                          ),
                          _buildInfoPoint(
                            Icons.trending_up,
                            'Resignation <3 years',
                            '50% of accrued amount',
                          ),
                          _buildInfoPoint(
                            Icons.trending_up,
                            'Resignation 3+ years',
                            '100% of accrued amount',
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Key Concepts',
                              style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(12.h),
                            _buildInfoPoint(
                              Icons.check_circle_outline,
                              'Accrual Slabs',
                              'Different rates apply based on service duration',
                            ),
                            _buildInfoPoint(
                              Icons.check_circle_outline,
                              'Basis',
                              'Component used for calculation (usually basic salary)',
                            ),
                            _buildInfoPoint(
                              Icons.check_circle_outline,
                              'Resignation Penalty',
                              'Reduced entitlement for voluntary resignation',
                            ),
                            _buildInfoPoint(
                              Icons.check_circle_outline,
                              'Daily Rate',
                              'Monthly salary divided by 30 days',
                            ),
                          ],
                        ),
                      ),
                      Gap(48.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GCC Standard Practice',
                              style: context.textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gap(12.h),
                            _buildInfoPoint(
                              Icons.trending_up,
                              'First 5 years',
                              '21 days per year of service',
                            ),
                            _buildInfoPoint(
                              Icons.trending_up,
                              'After 5 years',
                              '30 days per year of service',
                            ),
                            _buildInfoPoint(
                              Icons.trending_up,
                              'Resignation <3 years',
                              '50% of accrued amount',
                            ),
                            _buildInfoPoint(
                              Icons.trending_up,
                              'Resignation 3+ years',
                              '100% of accrued amount',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPoint(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 16.sp),
          Gap(8.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  TextSpan(
                    text: description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
