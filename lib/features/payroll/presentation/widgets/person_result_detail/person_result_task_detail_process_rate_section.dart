import 'dart:math' as math;
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailProcessRateSection extends StatelessWidget {
  const PersonResultTaskDetailProcessRateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenLayout.isMobile;
    final isTablet = context.screenLayout.isTablet;
    final useSidebarBelow = isMobile || isTablet;

    final tablesColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _RateDetailsTableCard(isHoursTable: true),
        Gap(16.h),
        const _RateDetailsTableCard(isHoursTable: false),
      ],
    );

    final sidebarColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _EarningsBreakdownCard(),
        Gap(16.h),
        const _ExecutionMetricsCard(),
        Gap(16.h),
        const _PayrollDistributionCard(),
      ],
    );

    if (useSidebarBelow) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [tablesColumn, Gap(20.h), sidebarColumn]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: tablesColumn),
        Gap(20.w),
        SizedBox(width: 320.w, child: sidebarColumn),
      ],
    );
  }
}

class _RateDetailsTableCard extends StatelessWidget {
  const _RateDetailsTableCard({required this.isHoursTable});

  final bool isHoursTable;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final rows = _buildRows(loc);
    final lastColumnLabel = isHoursTable
        ? loc.payrollPersonResultsTaskDetailHours
        : loc.payrollPersonResultsTaskDetailDays;
    final title = isHoursTable
        ? loc.payrollPersonResultsTaskDetailRateDetailsHours
        : loc.payrollPersonResultsTaskDetailRateDetailsDays;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 20.h),

            child: Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(
                fontSize: 16.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth = _rateTableContentWidth();
              final tableWidth = constraints.hasBoundedWidth
                  ? math.max(contentWidth, constraints.maxWidth)
                  : contentWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _RateDetailsTableHeader(lastColumnLabel: lastColumnLabel),
                      for (var index = 0; index < rows.length; index++) _RateDetailsTableRow(data: rows[index]),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<_RateDetailsRowData> _buildRows(AppLocalizations loc) {
    if (isHoursTable) {
      return [
        _RateDetailsRowData(
          elementName: loc.payrollPersonResultsTaskDetailElementBasicSalaryKw,
          classification: loc.payrollPersonResultsTaskDetailClassificationEarnings,
          amount: loc.payrollPersonResultsTaskDetailBasicSalaryAmount,
          rate: loc.payrollPersonResultsTaskDetailBasicSalaryHourlyRate,
          quantity: loc.payrollPersonResultsTaskDetailBasicSalaryHours,
        ),
        _RateDetailsRowData(
          elementName: loc.payrollPersonResultsTaskDetailElementHousingAllowanceKw,
          classification: loc.payrollPersonResultsTaskDetailClassificationAllowances,
          amount: loc.payrollPersonResultsTaskDetailHousingAllowanceAmount,
          rate: loc.payrollPersonResultsTaskDetailHousingAllowanceHourlyRate,
          quantity: loc.payrollPersonResultsTaskDetailHousingAllowanceHours,
        ),
      ];
    }

    return [
      _RateDetailsRowData(
        elementName: loc.payrollPersonResultsTaskDetailElementBasicSalaryKw,
        classification: loc.payrollPersonResultsTaskDetailClassificationEarnings,
        amount: loc.payrollPersonResultsTaskDetailBasicSalaryAmount,
        rate: loc.payrollPersonResultsTaskDetailBasicSalaryDailyRate,
        quantity: loc.payrollPersonResultsTaskDetailBasicSalaryDays,
      ),
      _RateDetailsRowData(
        elementName: loc.payrollPersonResultsTaskDetailElementHousingAllowanceKw,
        classification: loc.payrollPersonResultsTaskDetailClassificationAllowances,
        amount: loc.payrollPersonResultsTaskDetailHousingAllowanceAmount,
        rate: loc.payrollPersonResultsTaskDetailHousingAllowanceDailyRate,
        quantity: loc.payrollPersonResultsTaskDetailHousingAllowanceDays,
      ),
    ];
  }
}

double _rateTableContentWidth() => 200.w + 220.w + 150.w + 140.w + 90.w + 32.w;

class _RateDetailsRowData {
  const _RateDetailsRowData({
    required this.elementName,
    required this.classification,
    required this.amount,
    required this.rate,
    required this.quantity,
  });

  final String elementName;
  final String classification;
  final String amount;
  final String rate;
  final String quantity;
}

class _RateDetailsTableHeader extends StatelessWidget {
  const _RateDetailsTableHeader({required this.lastColumnLabel});

  final String lastColumnLabel;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final headerBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final headerColor = isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText;
    final headerStyle = context.textTheme.labelLarge?.copyWith(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      height: 18 / 12,
      letterSpacing: 0.48,
      color: headerColor,
    );

    return Container(
      color: headerBg,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 11.h),
      child: Row(
        children: [
          SizedBox(
            width: 200.w,
            child: Text(loc.payrollPersonResultsTaskDetailElementName.toUpperCase(), style: headerStyle),
          ),
          SizedBox(
            width: 220.w,
            child: Text(loc.payrollPersonResultsTaskDetailElementClassification.toUpperCase(), style: headerStyle),
          ),
          SizedBox(
            width: 150.w,
            child: Text(
              loc.payrollPersonResultsTaskDetailAmount.toUpperCase(),
              textAlign: TextAlign.end,
              style: headerStyle,
            ),
          ),
          SizedBox(
            width: 140.w,
            child: Text(
              loc.payrollPersonResultsTaskDetailRate.toUpperCase(),
              textAlign: TextAlign.end,
              style: headerStyle,
            ),
          ),
          SizedBox(
            width: 90.w,
            child: Text(lastColumnLabel.toUpperCase(), textAlign: TextAlign.end, style: headerStyle),
          ),
        ],
      ),
    );
  }
}

class _RateDetailsTableRow extends StatelessWidget {
  const _RateDetailsTableRow({required this.data});

  final _RateDetailsRowData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cellColor = isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate;
    final cellStyle = context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, height: 19.5 / 13, color: cellColor);
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBackgroundGrey;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor)),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 200.w,
            child: Text(data.elementName, style: cellStyle),
          ),
          SizedBox(
            width: 220.w,
            child: Text(data.classification, style: cellStyle),
          ),
          SizedBox(
            width: 150.w,
            child: Text(data.amount, textAlign: TextAlign.end, style: cellStyle),
          ),
          SizedBox(
            width: 140.w,
            child: Text(data.rate, textAlign: TextAlign.end, style: cellStyle),
          ),
          SizedBox(
            width: 90.w,
            child: Text(data.quantity, textAlign: TextAlign.end, style: cellStyle),
          ),
        ],
      ),
    );
  }
}

class _EarningsBreakdownCard extends StatelessWidget {
  const _EarningsBreakdownCard();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final items = [
      _EarningsBreakdownItemData(
        label: loc.payrollPersonResultsTaskDetailBasicSalary,
        value: loc.payrollPersonResultsTaskDetailBasicSalaryBreakdownValue,
        progress: 0.85,
        progressColor: AppColors.alertNew,
        valueColor: AppColors.alertNew,
      ),
      _EarningsBreakdownItemData(
        label: loc.payrollPersonResultsTaskDetailHousingAllowShort,
        value: loc.payrollPersonResultsTaskDetailHousingAllowanceBreakdownValue,
        progress: 0.15,
        progressColor: AppColors.purpleBorderDark,
        valueColor: AppColors.purpleBorderDark,
      ),
      _EarningsBreakdownItemData(
        label: loc.payrollPersonResultsTaskDetailOther,
        value: loc.payrollPersonResultsTaskDetailOtherBreakdownValue,
        progress: 0,
        progressColor: isDark ? AppColors.grayBorderDark : AppColors.cardBorder,
        valueColor: isDark ? AppColors.textMutedDark : AppColors.cardBorder,
      ),
    ];

    return _SidebarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarCardHeader(
            title: loc.payrollPersonResultsTaskDetailEarningsBreakdown,
            iconPath: Assets.icons.analyticsIcon.path,
          ),
          Gap(11.h),
          for (var index = 0; index < items.length; index++) ...[
            if (index > 0) Gap(11.h),
            _EarningsBreakdownItem(data: items[index]),
          ],
        ],
      ),
    );
  }
}

class _EarningsBreakdownItemData {
  const _EarningsBreakdownItemData({
    required this.label,
    required this.value,
    required this.progress,
    required this.progressColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final double progress;
  final Color progressColor;
  final Color valueColor;
}

class _EarningsBreakdownItem extends StatelessWidget {
  const _EarningsBreakdownItem({required this.data});

  final _EarningsBreakdownItemData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.textTertiaryDark : AppColors.textPlaceholder;
    final trackColor = isDark ? AppColors.grayBgDark : AppColors.cardBackgroundGrey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                data.label,
                style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, height: 18 / 12, color: labelColor),
              ),
            ),
            Text(
              data.value,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 18 / 12,
                color: data.valueColor,
              ),
            ),
          ],
        ),
        Gap(4.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(999.r),
          child: SizedBox(
            height: 7.h,
            child: Stack(
              children: [
                Container(color: trackColor),
                if (data.progress > 0)
                  FractionallySizedBox(
                    widthFactor: data.progress,
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(color: data.progressColor),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ExecutionMetricsCard extends StatelessWidget {
  const _ExecutionMetricsCard();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final metrics = [
      _ExecutionMetricData(
        label: loc.payrollPersonResultsTaskDetailProcessingTime,
        value: loc.payrollPersonResultsTaskDetailProcessingTimeValue,
        backgroundColor: isDark ? AppColors.successBgDark.withValues(alpha: 0.35) : AppColors.greenBg,
        foregroundColor: isDark ? AppColors.successTextDark : AppColors.greenTextSecondary,
      ),
      _ExecutionMetricData(
        label: loc.payrollPersonResultsTaskDetailElementsProcessed,
        value: loc.payrollPersonResultsTaskDetailElementsProcessedValue,
        backgroundColor: isDark ? AppColors.infoBgDark.withValues(alpha: 0.35) : AppColors.alertNewBg,
        foregroundColor: isDark ? AppColors.infoTextDark : AppColors.infoTextSecondary,
      ),
      _ExecutionMetricData(
        label: loc.payrollPersonResultsTaskDetailCalculationRules,
        value: loc.payrollPersonResultsTaskDetailCalculationRulesValue,
        backgroundColor: isDark ? AppColors.purpleBgDark.withValues(alpha: 0.35) : AppColors.purpleBg,
        foregroundColor: isDark ? AppColors.purpleTextDark : AppColors.purpleTextSecondary,
      ),
      _ExecutionMetricData(
        label: loc.payrollPersonResultsTaskDetailErrorsWarnings,
        value: loc.payrollPersonResultsTaskDetailErrorsWarningsValue,
        backgroundColor: isDark ? AppColors.grayBgDark : AppColors.cardBackgroundGrey,
        foregroundColor: isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
      ),
    ];

    return _SidebarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SidebarCardHeader(
            title: loc.payrollPersonResultsTaskDetailExecutionMetrics,
            iconPath: Assets.icons.payroll.process.path,
          ),
          Gap(8.h),
          for (var index = 0; index < metrics.length; index++) ...[
            if (index > 0) Gap(8.h),
            _ExecutionMetricRow(data: metrics[index]),
          ],
        ],
      ),
    );
  }
}

class _ExecutionMetricData {
  const _ExecutionMetricData({
    required this.label,
    required this.value,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final String value;
  final Color backgroundColor;
  final Color foregroundColor;
}

class _ExecutionMetricRow extends StatelessWidget {
  const _ExecutionMetricRow({required this.data});

  final _ExecutionMetricData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(12.w, 9.h, 12.w, 9.h),
      decoration: BoxDecoration(color: data.backgroundColor, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          Expanded(
            child: Text(data.label, style: context.textTheme.labelMedium?.copyWith(color: data.foregroundColor)),
          ),
          Text(
            data.value,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: data.foregroundColor),
          ),
        ],
      ),
    );
  }
}

class _PayrollDistributionCard extends StatelessWidget {
  const _PayrollDistributionCard();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final rows = [
      (loc.payrollPersonResultsTaskDetailGrossPay, loc.payrollPersonResultsTaskDetailGrossPayValue),
      (loc.payrollPersonResultsTaskDetailDeductions, loc.payrollPersonResultsTaskDetailDeductionsValue),
      (loc.payrollPersonResultsTaskDetailNetPay, loc.payrollPersonResultsTaskDetailNetPayValue),
      (loc.payrollPersonResultsTaskDetailEmployerCost, loc.payrollPersonResultsTaskDetailEmployerCostValue),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: AppColors.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.payrollPersonResultsTaskDetailPayrollDistribution,
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: AppColors.onPrimary),
          ),
          Gap(14.h),
          for (final row in rows)
            Container(
              padding: EdgeInsetsDirectional.fromSTEB(0, 7.h, 0, 8.h),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.onPrimary.withValues(alpha: 0.12))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      row.$1,
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  Text(
                    row.$2,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SidebarCard extends StatelessWidget {
  const _SidebarCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}

class _SidebarCardHeader extends StatelessWidget {
  const _SidebarCardHeader({required this.title, required this.iconPath});

  final String title;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      children: [
        DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: AppColors.primary),
        Gap(8.w),
        Expanded(
          child: Text(
            title,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 14.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
