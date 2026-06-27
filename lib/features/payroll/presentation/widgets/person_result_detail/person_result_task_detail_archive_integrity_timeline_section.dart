import 'dart:math' as math;

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailArchiveIntegrityTimelineSection extends StatelessWidget {
  const PersonResultTaskDetailArchiveIntegrityTimelineSection({super.key});

  static const int _integrityCheckCount = 6;
  static const int _timelineStepCount = 5;

  static double sharedContentHeight() {
    final checksHeight = _integrityCheckCount * _DataIntegrityCheckRow.rowHeight + (_integrityCheckCount - 1) * 1.h;
    final timelineHeight = _timelineStepCount * _PayrollLifecycleTimelineStep.stepHeight;
    return math.max(checksHeight, timelineHeight);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenLayout.isMobile;
    final cardGap = 16.w;
    final contentHeight = isMobile ? null : sharedContentHeight();

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DataIntegrityChecksCard(contentHeight: contentHeight),
          Gap(cardGap),
          _PayrollLifecycleTimelineCard(contentHeight: contentHeight),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _DataIntegrityChecksCard(contentHeight: contentHeight)),
        Gap(cardGap),
        Expanded(child: _PayrollLifecycleTimelineCard(contentHeight: contentHeight)),
      ],
    );
  }
}

class _ArchiveSectionCard extends StatelessWidget {
  const _ArchiveSectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.09)),
        boxShadow: AppShadows.cardShadow,
      ),
      child: child,
    );
  }
}

class _DataIntegrityChecksCard extends StatelessWidget {
  const _DataIntegrityChecksCard({this.contentHeight});

  final double? contentHeight;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final checks = _buildChecks(loc);

    final checksContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var index = 0; index < checks.length; index++) ...[
          _DataIntegrityCheckRow(label: checks[index]),
          if (index < checks.length - 1) DigifyDivider.horizontal(),
        ],
      ],
    );

    return _ArchiveSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.payrollPersonResultsTaskDetailDataIntegrityChecksTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 15.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          if (contentHeight != null) SizedBox(height: contentHeight, child: checksContent) else checksContent,
        ],
      ),
    );
  }

  List<String> _buildChecks(AppLocalizations loc) {
    return [
      loc.payrollPersonResultsTaskDetailPayrollBalanceReconciliation,
      loc.payrollPersonResultsTaskDetailElementEntryCompleteness,
      loc.payrollPersonResultsTaskDetailCostingDistributionVerified,
      loc.payrollPersonResultsTaskDetailNetPayReconciliation,
      loc.payrollPersonResultsTaskDetailDuplicateRecordCheck,
      loc.payrollPersonResultsTaskDetailArchiveChecksumVerified,
    ];
  }
}

class _DataIntegrityCheckRow extends StatelessWidget {
  const _DataIntegrityCheckRow({required this.label});

  static double get rowHeight => 52.h;

  final String label;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return SizedBox(
      height: rowHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
              ),
            ),
          ),
          Gap(12.w),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyCapsule(
                label: loc.payrollPersonResultsTaskDetailCheckPassed,
                backgroundColor: isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg,
                textColor: isDark ? AppColors.info : AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayrollLifecycleTimelineCard extends StatelessWidget {
  const _PayrollLifecycleTimelineCard({this.contentHeight});

  final double? contentHeight;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final steps = _buildSteps(loc);

    final timelineContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var index = 0; index < steps.length; index++)
          _PayrollLifecycleTimelineStep(data: steps[index], showConnector: index < steps.length - 1),
      ],
    );

    return _ArchiveSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            loc.payrollPersonResultsTaskDetailPayrollLifecycleTimelineTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 15.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(16.h),
          if (contentHeight != null) SizedBox(height: contentHeight, child: timelineContent) else timelineContent,
        ],
      ),
    );
  }

  List<PersonResultTaskDetailArchiveLifecycleStepData> _buildSteps(AppLocalizations loc) {
    return [
      PersonResultTaskDetailArchiveLifecycleStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineCalculated,
        date: loc.payrollPersonResultsTaskDetailArchiveTimelineCalculatedDate,
      ),
      PersonResultTaskDetailArchiveLifecycleStepData(
        title: loc.payrollPersonResultsTaskDetailTimelinePrepaymentsProcessed,
        date: loc.payrollPersonResultsTaskDetailArchiveTimelinePrepaymentsDate,
      ),
      PersonResultTaskDetailArchiveLifecycleStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineCostingCompleted,
        date: loc.payrollPersonResultsTaskDetailArchiveTimelineCostingDate,
      ),
      PersonResultTaskDetailArchiveLifecycleStepData(
        title: loc.payrollPersonResultsTaskDetailTimelinePayslipGenerated,
        date: loc.payrollPersonResultsTaskDetailArchiveTimelinePayslipsDate,
      ),
      PersonResultTaskDetailArchiveLifecycleStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineResultsArchived,
        date: loc.payrollPersonResultsTaskDetailArchiveTimelineArchivedDate,
      ),
    ];
  }
}

class PersonResultTaskDetailArchiveLifecycleStepData {
  const PersonResultTaskDetailArchiveLifecycleStepData({required this.title, required this.date});

  final String title;
  final String date;
}

class _PayrollLifecycleTimelineStep extends StatelessWidget {
  const _PayrollLifecycleTimelineStep({required this.data, required this.showConnector});

  static double get stepHeight => 64.h;

  final PersonResultTaskDetailArchiveLifecycleStepData data;
  final bool showConnector;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final connectorColor = isDark ? AppColors.infoBorderDark.withValues(alpha: 0.5) : AppColors.infoTextDark;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final dateColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return SizedBox(
      height: stepHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32.w,
            child: Column(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(100.r)),
                  alignment: Alignment.center,
                  child: DigifyAsset(
                    assetPath: Assets.icons.checkIconGreen.path,
                    color: AppColors.onPrimary,
                    width: 16.w,
                    height: 16.w,
                  ),
                ),
                if (showConnector)
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.symmetric(vertical: 4.h),
                      child: Container(width: 2.w, color: connectorColor),
                    ),
                  ),
              ],
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(data.title, style: context.textTheme.labelLarge?.copyWith(color: titleColor)),
                  Gap(2.h),
                  Text(data.date, style: context.textTheme.labelSmall?.copyWith(color: dateColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
