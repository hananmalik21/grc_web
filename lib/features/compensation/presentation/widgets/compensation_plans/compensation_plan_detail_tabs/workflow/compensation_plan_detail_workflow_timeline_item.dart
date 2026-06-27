import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'compensation_plan_detail_workflow_data.dart';

class CompensationPlanDetailWorkflowTimelineItem extends StatelessWidget {
  final WorkflowEvent event;
  final bool showConnector;

  const CompensationPlanDetailWorkflowTimelineItem({super.key, required this.event, this.showConnector = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final connectorColor = isDark ? AppColors.borderGreyDark : AppColors.cardBorder;

    return Padding(
      padding: EdgeInsets.only(bottom: showConnector ? 10.h : 0),
      child: Stack(
        children: [
          if (showConnector)
            Positioned(
              left: (24.w - 2.w) / 2,
              top: 28.h,
              bottom: 0,
              child: Container(width: 2.w, color: connectorColor),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24.w,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: DigifyAsset(
                    assetPath: Assets.icons.checkIconGreen.path,
                    color: AppColors.primary,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: context.textTheme.titleSmall?.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Gap(16.w),
                        Text(
                          event.timestamp,
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 12.sp,
                            color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarSecondaryText,
                          ),
                        ),
                      ],
                    ),
                    Gap(4.h),
                    Text(
                      event.description,
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                    Gap(4.h),
                    _ActorRow(actor: event.actor),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActorRow extends StatelessWidget {
  final WorkflowActor actor;

  const _ActorRow({required this.actor});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.24) : AppColors.dutyRoleGradientStart;

    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: Row(
        children: [
          AppAvatar(size: 24.w, fallbackInitial: actor.name, backgroundColor: bg),
          Gap(8.w),
          Text(
            actor.name,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
