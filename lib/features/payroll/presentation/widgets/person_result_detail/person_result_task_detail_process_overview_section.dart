import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailProcessOverviewSection extends StatelessWidget {
  const PersonResultTaskDetailProcessOverviewSection({super.key, required this.task});

  final PayrollProcessResultTask task;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final fields = _buildFields(loc);

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OverviewHeader(isMobile: isMobile),
          Gap(28.h),
          _OverviewFieldsGrid(fields: fields),
        ],
      ),
    );
  }

  List<PersonResultTaskDetailProcessOverviewFieldData> _buildFields(AppLocalizations loc) {
    return [
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailPayrollFlow,
        value: '${task.flowName}\n${loc.payrollPersonResultsTaskDetailPayrollFlowSalary(task.payrollPeriod)}',
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailStatutoryPeriod,
        value: loc.payrollPersonResultsTaskDetailStatutoryPeriodValue,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailPeriodEndDate,
        value: task.processDate,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailProcessConfigurationGroup,
        value: loc.payrollPersonResultsTaskDetailProcessConfigurationGroupValue,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(label: loc.payrollPersonResultsPayrollColumn, value: task.payroll),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailDateEarned,
        value: task.processDate,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailConsolidationGroup,
        value: loc.payrollPersonResultsTaskDetailConsolidationGroupValue,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailRunType,
        value: loc.payrollPersonResultsTaskDetailProcessTypeRegularNormal,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailPeriodName,
        value: loc.payrollPersonResultsTaskDetailPeriodNameValue(task.payrollPeriod),
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailPeriodStartDate,
        value: task.processDate,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailPayrollRelationshipNumber,
        value: loc.payrollPersonResultsTaskDetailPayrollRelationshipNumberValue,
      ),
      PersonResultTaskDetailProcessOverviewFieldData(
        label: loc.payrollPersonResultsTaskDetailPaymentMethod,
        value: loc.payrollPersonResultsTaskDetailPaymentMethodValue,
      ),
    ];
  }
}

class PersonResultTaskDetailProcessOverviewFieldData {
  const PersonResultTaskDetailProcessOverviewFieldData({required this.label, required this.value});

  final String label;
  final String value;
}

class _OverviewHeader extends StatelessWidget {
  const _OverviewHeader({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final titleBlock = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.analyticsIcon.path,
            width: 22,
            height: 22,
            color: AppColors.primary,
          ),
        ),
        Gap(14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.payrollPersonResultsTaskDetailProcessOverviewTitle,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(2.h),
              Text(
                loc.payrollPersonResultsTaskDetailProcessOverviewSubtitle,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [titleBlock]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [Expanded(child: titleBlock)],
    );
  }
}

class _OverviewFieldsGrid extends StatelessWidget {
  const _OverviewFieldsGrid({required this.fields});

  final List<PersonResultTaskDetailProcessOverviewFieldData> fields;

  @override
  Widget build(BuildContext context) {
    final columnCount = _columnCount(context);
    final rowCount = (fields.length / columnCount).ceil();
    final horizontalGap = context.screenLayout.isMobile ? 0.0 : 32.w;
    final verticalGap = 24.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) Gap(verticalGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columnCount; column++) ...[
                if (column > 0) Gap(horizontalGap),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: _buildFieldAt(row: row, column: column, columnCount: columnCount),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  int _columnCount(BuildContext context) {
    if (context.screenLayout.isMobile) return 1;
    if (context.screenLayout.isTablet) return 2;
    return 3;
  }

  Widget _buildFieldAt({required int row, required int column, required int columnCount}) {
    final index = row * columnCount + column;
    if (index >= fields.length) {
      return const SizedBox.shrink();
    }

    return PersonResultTaskDetailProcessOverviewField(data: fields[index]);
  }
}

class PersonResultTaskDetailProcessOverviewField extends StatelessWidget {
  const PersonResultTaskDetailProcessOverviewField({super.key, required this.data});

  final PersonResultTaskDetailProcessOverviewFieldData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.grayTextDark : AppColors.textPlaceholder;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final fieldBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final fieldBorder = isDark ? AppColors.cardBorderDark : AppColors.cardBackgroundGrey;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(19.w, 17.h, 19.w, 17.h),
      decoration: BoxDecoration(
        color: fieldBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.label.toUpperCase(),
            style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: labelColor),
          ),
          Gap(6.h),
          Text(
            data.value,
            style: context.textTheme.titleMedium?.copyWith(fontSize: 15.sp, color: valueColor),
          ),
        ],
      ),
    );
  }
}
