import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/dashboard/domain/models/dashboard_event.dart';
import 'package:grc/features/dashboard/domain/models/dashboard_task.dart';
import 'package:grc/features/dashboard/presentation/providers/events_provider.dart';
import 'package:grc/features/dashboard/presentation/providers/tasks_provider.dart';
import 'package:grc/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TasksEventsCard extends ConsumerWidget {
  final AppLocalizations localizations;
  final VoidCallback? onEyeIconTap;

  const TasksEventsCard({super.key, required this.localizations, this.onEyeIconTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    final events = ref.watch(eventsProvider);
    final isMinimized = ref.watch(tasksMinimizedProvider);

    final cardPadding = context.responsiveFine(
      mobile: 16.0.w,
      tabletSmall: 16.0.w,
      tabletMedium: 14.0.w,
      tabletLarge: 14.0.w,
      desktop: 14.0.w,
    );
    final sectionSpacing = context.responsive(mobile: 10.0.h, desktop: 7.0.h);
    final itemSpacing = context.responsive(mobile: 9.0.h, desktop: 7.0.h);
    final labelFontSize = context.responsive(mobile: 11.0.sp, desktop: 10.0.sp);

    return Container(
      padding: EdgeInsetsDirectional.all(cardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.25.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF2B7FFF), Color(0xFF615FFF)],
                        ),
                        borderRadius: BorderRadius.circular(7.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: DigifyAsset(
                        assetPath: Assets.icons.tasksIcon.path,
                        width: 14,
                        height: 14,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(7),
                    Expanded(
                      child: Text(
                        localizations.tasksEvents,
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: context.themeTextPrimary,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  IconButton(
                    padding: EdgeInsets.all(3.5.w),
                    constraints: const BoxConstraints(),
                    icon: Icon(isMinimized ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded),
                    onPressed: () => ref.read(tasksMinimizedProvider.notifier).state = !isMinimized,
                  ),
                  const Gap(3.5),
                  IconButton(
                    padding: EdgeInsets.all(3.5.w),
                    constraints: const BoxConstraints(),
                    icon: DigifyAsset(
                      assetPath: Assets.icons.eyesIcon.path,
                      width: 14,
                      height: 14,
                      color: context.themeTextPrimary,
                    ),
                    onPressed: () => ref.read(tasksMinimizedProvider.notifier).state = !isMinimized,
                  ),
                ],
              ),
            ],
          ),

          if (!isMinimized) ...[
            Gap(sectionSpacing),
            Text(
              localizations.myTasks,
              style: context.labelSmall.copyWith(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: context.themeTextTertiary,
              ),
            ),

            Gap(itemSpacing),
            ...tasks.map(
              (task) => Padding(
                padding: EdgeInsets.only(bottom: itemSpacing),
                child: _buildTaskItem(context, ref, task),
              ),
            ),

            Gap(sectionSpacing),
            Text(
              localizations.upcomingEvents,
              style: context.labelSmall.copyWith(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w600,
                color: context.themeTextTertiary,
              ),
            ),

            const Gap(4),
            ...events.map((event) => _buildEventItem(context, event)),

            Gap(15.h),
            Center(
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  localizations.viewAllTasksEvents,
                  style: context.labelSmall.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, WidgetRef ref, DashboardTask task) {
    final isDark = context.isDark;
    final completedColor = AppColors.primary;
    final borderColor = context.themeBorderGrey;

    final textColor = task.isCompleted ? context.themeTextPlaceholder : context.themeTextPrimary;

    final subtitleColor = task.isCompleted ? context.themeTextPlaceholder : context.themeTextTertiary;

    final checkboxBg = task.isCompleted ? completedColor : (isDark ? AppColors.cardBackgroundDark : Colors.white);

    return InkWell(
      onTap: () => ref.read(tasksProvider.notifier).toggleTask(task.id),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 12.25.w,
            height: 12.25.h,
            margin: EdgeInsetsDirectional.only(top: 1.75.h),
            decoration: BoxDecoration(
              color: checkboxBg,
              border: Border.all(color: task.isCompleted ? completedColor : borderColor, width: 1),
              borderRadius: BorderRadius.circular(2.5.r),
            ),
            child: task.isCompleted ? Icon(Icons.check, size: 10.sp, color: Colors.white) : null,
          ),
          const Gap(7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: context.bodySmall.copyWith(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
                const Gap(1),
                Text(
                  task.subtitle,
                  style: context.bodySmall.copyWith(fontSize: 9.sp, fontWeight: FontWeight.w400, color: subtitleColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(BuildContext context, DashboardEvent event) {
    Color bgColor;
    Color textColor;

    switch (event.category) {
      case EventCategory.meeting:
        bgColor = context.themeInfoBg;
        textColor = context.themeInfoText;
        break;
      case EventCategory.payroll:
        bgColor = context.themeSuccessBg;
        textColor = context.themeSuccessText;
        break;
      case EventCategory.holiday:
        bgColor = context.themeWarningBg;
        textColor = context.themeWarningText;
        break;
    }

    bgColor = event.bgColor ?? bgColor;
    textColor = event.textColor ?? textColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 7.h),
          padding: EdgeInsetsDirectional.symmetric(horizontal: 9.39.w, vertical: 3.5.h),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(7.r)),
          child: Column(
            children: [
              Text(
                event.month,
                style: context.labelSmall.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600, color: textColor),
              ),
              Text(
                event.day,
                style: context.labelMedium.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w700, color: textColor),
              ),
            ],
          ),
        ),
        const Gap(7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.title,
                style: context.labelSmall.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: context.themeTextPrimary,
                ),
              ),
              const Gap(1),
              Text(
                event.time,
                style: context.bodySmall.copyWith(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w400,
                  color: context.themeTextTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
