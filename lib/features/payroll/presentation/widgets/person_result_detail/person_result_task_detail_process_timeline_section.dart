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

class PersonResultTaskDetailProcessTimelineSection extends StatelessWidget {
  const PersonResultTaskDetailProcessTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final steps = _buildSteps(loc);

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
          Text(
            loc.payrollPersonResultsTaskDetailPayrollTimelineTitle,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 16.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(24.h),
          _PayrollTimeline(steps: steps, isMobile: isMobile),
        ],
      ),
    );
  }

  List<PersonResultTaskDetailTimelineStepData> _buildSteps(AppLocalizations loc) {
    return [
      PersonResultTaskDetailTimelineStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineSubmitted,
        date: loc.payrollPersonResultsTaskDetailTimelineSubmittedDate,
      ),
      PersonResultTaskDetailTimelineStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineCalculated,
        date: loc.payrollPersonResultsTaskDetailTimelineCalculatedDate,
      ),
      PersonResultTaskDetailTimelineStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineCostingCompleted,
        date: loc.payrollPersonResultsTaskDetailTimelineCostingCompletedDate,
      ),
      PersonResultTaskDetailTimelineStepData(
        title: loc.payrollPersonResultsTaskDetailTimelinePayslipGenerated,
        date: loc.payrollPersonResultsTaskDetailTimelinePayslipGeneratedDate,
      ),
      PersonResultTaskDetailTimelineStepData(
        title: loc.payrollPersonResultsTaskDetailTimelineArchived,
        date: loc.payrollPersonResultsTaskDetailTimelineArchivedDate,
      ),
    ];
  }
}

class PersonResultTaskDetailTimelineStepData {
  const PersonResultTaskDetailTimelineStepData({required this.title, required this.date});

  final String title;
  final String date;
}

class _PayrollTimeline extends StatelessWidget {
  const _PayrollTimeline({required this.steps, required this.isMobile});

  final List<PersonResultTaskDetailTimelineStepData> steps;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _PayrollTimelineRow(steps: steps, itemWidth: 140.w),
      );
    }

    return _PayrollTimelineRow(steps: steps);
  }
}

class _PayrollTimelineRow extends StatelessWidget {
  const _PayrollTimelineRow({required this.steps, this.itemWidth});

  final List<PersonResultTaskDetailTimelineStepData> steps;
  final double? itemWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final lineColor = isDark ? AppColors.infoBorderDark.withValues(alpha: 0.5) : AppColors.infoBorder;
    final totalWidth = itemWidth != null ? itemWidth! * steps.length : null;

    Widget buildContent(double width) {
      return SizedBox(
        width: width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: width * 0.05,
              right: width * 0.05,
              top: 18.h,
              child: Container(height: 2.h, color: lineColor),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final step in steps)
                  if (itemWidth != null)
                    SizedBox(
                      width: itemWidth,
                      child: PersonResultTaskDetailTimelineStep(data: step),
                    )
                  else
                    Expanded(child: PersonResultTaskDetailTimelineStep(data: step)),
              ],
            ),
          ],
        ),
      );
    }

    if (totalWidth != null) {
      return buildContent(totalWidth);
    }

    return LayoutBuilder(builder: (context, constraints) => buildContent(constraints.maxWidth));
  }
}

class PersonResultTaskDetailTimelineStep extends StatelessWidget {
  const PersonResultTaskDetailTimelineStep({super.key, required this.data});

  final PersonResultTaskDetailTimelineStepData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final dateColor = isDark ? AppColors.textTertiaryDark : AppColors.textPlaceholder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            border: Border.all(color: isDark ? AppColors.cardBackgroundDark : AppColors.primary, width: 3),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(assetPath: Assets.icons.checkIconGreen.path, color: AppColors.onPrimary),
        ),
        Gap(10.h),
        Text(
          data.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: titleColor),
        ),
        Gap(2.h),
        Text(
          data.date,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(color: dateColor),
        ),
      ],
    );
  }
}
