import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/hiring/application/applications/utils/application_pipeline_utils.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

export 'package:grc/features/hiring/application/applications/utils/application_pipeline_utils.dart'
    show PipelineStepStatus;

class ApplicationHiringPipeline extends StatelessWidget {
  const ApplicationHiringPipeline({required this.detail, super.key});

  final ApplicationDetailData detail;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    final steps = buildApplicationPipelineSteps(
      loc: loc,
      effectiveStageCode: detail.effectivePipelineStageCode,
      isRejected: detail.isRejected,
    );

    return Container(
      padding: EdgeInsets.all(isMobile ? 16.w : 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  loc.hiringPipelineTitle,
                  style: (isMobile ? context.textTheme.titleMedium : context.textTheme.titleLarge)?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              if (detail.isRejected) DigifyStatusCapsule(status: loc.hiringPipelineRejected),
            ],
          ),
          Gap(isMobile ? 16.h : 24.h),
          if (isMobile)
            Column(
              children: List.generate(steps.length, (index) {
                return _buildMobileStepItem(
                  context,
                  steps[index],
                  isFirst: index == 0,
                  isLast: index == steps.length - 1,
                  prevStatus: index > 0 ? steps[index - 1].status : null,
                );
              }),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(steps.length, (index) {
                return Expanded(
                  child: _buildDesktopStepItem(
                    context,
                    steps[index],
                    isFirst: index == 0,
                    isLast: index == steps.length - 1,
                    prevStatus: index > 0 ? steps[index - 1].status : null,
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopStepItem(
    BuildContext context,
    ApplicationPipelineStepView data, {
    required bool isFirst,
    required bool isLast,
    PipelineStepStatus? prevStatus,
  }) {
    final isDark = context.isDark;
    final isCompletedOrCurrent =
        data.status == PipelineStepStatus.completed || data.status == PipelineStepStatus.current;

    final Color leftLineColor = (prevStatus == PipelineStepStatus.completed)
        ? AppColors.success
        : (isDark ? AppColors.grayBorderDark : AppColors.grayBorder.withValues(alpha: 0.3));

    final Color rightLineColor = (data.status == PipelineStepStatus.completed)
        ? AppColors.success
        : (isDark ? AppColors.grayBorderDark : AppColors.grayBorder.withValues(alpha: 0.3));

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(height: 2.h, color: isFirst ? Colors.transparent : leftLineColor),
                ),
                Expanded(
                  child: Container(height: 2.h, color: isLast ? Colors.transparent : rightLineColor),
                ),
              ],
            ),
            _buildStepCircle(context, data.status, isCompletedOrCurrent),
          ],
        ),
        Gap(8.h),
        Text(
          data.label,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: data.status == PipelineStepStatus.current ? FontWeight.bold : FontWeight.w500,
            color: data.status == PipelineStepStatus.pending
                ? (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary)
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMobileStepItem(
    BuildContext context,
    ApplicationPipelineStepView data, {
    required bool isFirst,
    required bool isLast,
    PipelineStepStatus? prevStatus,
  }) {
    final isDark = context.isDark;
    final isCompletedOrCurrent =
        data.status == PipelineStepStatus.completed || data.status == PipelineStepStatus.current;

    final Color topLineColor = (prevStatus == PipelineStepStatus.completed)
        ? AppColors.success
        : (isDark ? AppColors.grayBorderDark : AppColors.grayBorder.withValues(alpha: 0.3));

    final Color bottomLineColor = (data.status == PipelineStepStatus.completed)
        ? AppColors.success
        : (isDark ? AppColors.grayBorderDark : AppColors.grayBorder.withValues(alpha: 0.3));

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(width: 2.w, height: 12.h, color: isFirst ? Colors.transparent : topLineColor),
              _buildStepCircle(context, data.status, isCompletedOrCurrent, size: 32.w),
              Expanded(
                child: Container(width: 2.w, color: isLast ? Colors.transparent : bottomLineColor),
              ),
            ],
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(12.h),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: 32.w),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      data.label,
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: data.status == PipelineStepStatus.current ? FontWeight.bold : FontWeight.w500,
                        color: data.status == PipelineStepStatus.pending
                            ? (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary)
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
                if (!isLast) Gap(24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle(BuildContext context, PipelineStepStatus status, bool isCompletedOrCurrent, {double? size}) {
    final isDark = context.isDark;
    final double circleSize = size ?? 40.w;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        color: isCompletedOrCurrent ? AppColors.statIconGreen : (isDark ? AppColors.grayBgDark : AppColors.grayBg),
        shape: BoxShape.circle,
        border: status == PipelineStepStatus.pending
            ? Border.all(color: isDark ? AppColors.grayBorderDark : AppColors.grayBorder, width: 2.w)
            : null,
      ),
      alignment: Alignment.center,
      child: isCompletedOrCurrent
          ? DigifyAsset(
              assetPath: Assets.icons.checkIconGreen.path,
              color: AppColors.cardBackground,
              width: circleSize * 0.5,
              height: circleSize * 0.5,
            )
          : Icon(
              Icons.circle_outlined,
              color: isDark ? AppColors.grayTextDark : AppColors.grayText,
              size: circleSize * 0.5,
            ),
    );
  }
}
