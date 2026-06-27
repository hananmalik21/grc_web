import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_message_row_data.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/messages_table/person_result_task_detail_messages_severity_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailMessagesExpandedPanel extends StatelessWidget {
  const PersonResultTaskDetailMessagesExpandedPanel({required this.data, super.key});

  final PersonResultTaskDetailMessageRowData data;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final style = personResultTaskDetailMessageExpandedStyle(data.severity, isDark);
    final severityLabel = personResultTaskDetailMessageSeverityLabel(loc, data.severity);
    final title = loc.payrollPersonResultsTaskDetailMessagesExpandedTitle(severityLabel, data.taskName);
    final panelBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final labelColor = isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final timestampColor = isDark ? AppColors.textTertiaryDark : AppColors.textPlaceholder;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: panelBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: style.borderColor),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsetsDirectional.all(20.w),
            decoration: BoxDecoration(
              color: style.headerBackground,
              border: Border(bottom: BorderSide(color: style.borderColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(color: style.iconBackground, borderRadius: BorderRadius.circular(10.r)),
                  child: Center(
                    child: DigifyAsset(
                      assetPath: style.iconPath,
                      width: 16,
                      height: 16,
                      color: AppColors.buttonTextLight,
                    ),
                  ),
                ),
                Gap(10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: valueColor),
                      ),
                      Text(
                        data.processTimestamp,
                        style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: timestampColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.all(20.w),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _DetailField(
                        label: loc.payrollPersonResultsTaskDetailMessagesPayrollElement,
                        value: data.payrollElement,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                      Gap(16.h),
                      _DetailField(
                        label: loc.payrollPersonResultsTaskDetailPayrollRelationship,
                        value: data.payrollRelationship,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                      Gap(16.h),
                      _DetailField(
                        label: loc.payrollPersonResultsTaskName,
                        value: data.taskName,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                      Gap(16.h),
                      _DetailField(
                        label: loc.payrollPersonResultsTaskDetailMessagesProcessTimestamp,
                        value: data.processTimestamp,
                        labelColor: labelColor,
                        valueColor: valueColor,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _DetailField(
                              label: loc.payrollPersonResultsTaskDetailMessagesPayrollElement,
                              value: data.payrollElement,
                              labelColor: labelColor,
                              valueColor: valueColor,
                            ),
                          ),
                          Gap(32.w),
                          Expanded(
                            child: _DetailField(
                              label: loc.payrollPersonResultsTaskDetailPayrollRelationship,
                              value: data.payrollRelationship,
                              labelColor: labelColor,
                              valueColor: valueColor,
                            ),
                          ),
                        ],
                      ),
                      Gap(16.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _DetailField(
                              label: loc.payrollPersonResultsTaskName,
                              value: data.taskName,
                              labelColor: labelColor,
                              valueColor: valueColor,
                            ),
                          ),
                          Gap(32.w),
                          Expanded(
                            child: _DetailField(
                              label: loc.payrollPersonResultsTaskDetailMessagesProcessTimestamp,
                              value: data.processTimestamp,
                              labelColor: labelColor,
                              valueColor: valueColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22.w, 0, 22.w, 20.h),
            child: _FormulaTraceSection(trace: data.formulaTrace, isDark: isDark),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(22.w, 0, 22.w, 20.h),
            child: _SuggestedResolutionSection(resolution: data.suggestedResolution, isDark: isDark),
          ),
        ],
      ),
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.value, required this.labelColor, required this.valueColor});

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: context.textTheme.labelLarge?.copyWith(fontSize: 11.sp, color: labelColor),
        ),
        Gap(4.h),
        Text(value, style: context.textTheme.labelLarge?.copyWith(color: valueColor)),
      ],
    );
  }
}

class _FormulaTraceSection extends StatelessWidget {
  const _FormulaTraceSection({required this.trace, required this.isDark});

  final String trace;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final background = isDark ? AppColors.backgroundDark : AppColors.textPrimary;
    final labelColor = isDark ? AppColors.infoTextDark : AppColors.traceColor;
    final traceColor = AppColors.commandText;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.payrollPersonResultsTaskDetailMessagesFormulaTrace.toUpperCase(),
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 11.sp, color: labelColor),
          ),
          Gap(8.h),
          Text(
            trace,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: traceColor),
          ),
        ],
      ),
    );
  }
}

class _SuggestedResolutionSection extends StatelessWidget {
  const _SuggestedResolutionSection({required this.resolution, required this.isDark});

  final String resolution;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final background = isDark ? AppColors.successBgDark.withValues(alpha: 0.35) : AppColors.alertResolvedBg;
    final borderColor = isDark ? AppColors.successBorderDark : AppColors.successBorder;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.payrollPersonResultsTaskDetailMessagesSuggestedResolution.toUpperCase(),
            style: context.textTheme.headlineMedium?.copyWith(fontSize: 11.sp, color: AppColors.successText),
          ),
          Gap(6.h),
          Text(resolution, style: context.textTheme.bodySmall?.copyWith(color: AppColors.successText)),
        ],
      ),
    );
  }
}
