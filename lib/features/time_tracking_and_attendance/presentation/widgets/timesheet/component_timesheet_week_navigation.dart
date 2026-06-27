import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WeekNavigation extends StatelessWidget {
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;
  final VoidCallback onCurrentWeek;
  final VoidCallback onClearFilter;
  final VoidCallback onApplyFilter;
  final bool isWeekFilterEnabled;
  final bool isDark;
  final bool isCurrentWeek;

  const WeekNavigation({
    super.key,
    required this.weekStartDate,
    required this.weekEndDate,
    required this.onPreviousWeek,
    required this.onNextWeek,
    required this.onCurrentWeek,
    required this.onClearFilter,
    required this.onApplyFilter,
    required this.isWeekFilterEnabled,
    required this.isDark,
    required this.isCurrentWeek,
  });

  String _formatWeekPeriod(DateTime start, DateTime end) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final startStr = '${months[start.month - 1]} ${start.day}${start.year != end.year ? ', ${start.year}' : ''}';
    final endStr = '${months[end.month - 1]} ${end.day}, ${end.year}';
    return '$startStr - $endStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.isMobile ? null : 65.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: context.isMobile ? 12.h : 0),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: context.isMobile
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.attendance.emptyCalander.path,
                      width: 18.w,
                      height: 18.w,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon,
                    ),
                    Gap(14.w),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left,
                        size: 20.r,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                      ),
                      onPressed: onPreviousWeek,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Gap(14.w),
                    Text(
                      'Week: ${_formatWeekPeriod(weekStartDate, weekEndDate)}',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      ),
                    ),
                    Gap(14.w),
                    IconButton(
                      icon: Icon(
                        Icons.chevron_right,
                        size: 20.r,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                      ),
                      onPressed: onNextWeek,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Gap(12.h),
                Row(children: [const Spacer(), _buildCurrentWeekIndicator(context)]),
              ],
            )
          : Row(
              children: [
                DigifyAsset(
                  assetPath: Assets.icons.attendance.emptyCalander.path,
                  width: 18.w,
                  height: 18.w,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon,
                ),
                Gap(14.w),
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    size: 20.r,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                  ),
                  onPressed: onPreviousWeek,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                Gap(14.w),
                Text(
                  'Week: ${_formatWeekPeriod(weekStartDate, weekEndDate)}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(14.w),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    size: 20.r,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textSecondary,
                  ),
                  onPressed: onNextWeek,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                _buildCurrentWeekIndicator(context),
              ],
            ),
    );
  }

  Widget _buildCurrentWeekIndicator(BuildContext context) {
    const currentWeekLabel = 'Current Week';
    const clearLabel = 'Clear';
    const applyLabel = 'Apply';

    final applyButton = AppButton.primary(label: applyLabel, onPressed: onApplyFilter, height: 32.w);

    final clearButton = AppButton.outline(
      label: clearLabel,
      onPressed: isWeekFilterEnabled ? onClearFilter : null,
      height: 32.w,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCurrentWeek)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.jobRoleBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              currentWeekLabel,
              style: context.textTheme.labelMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
                fontSize: 14.sp,
              ),
            ),
          ),
        if (isCurrentWeek) Gap(8.w),
        applyButton,
        if (isWeekFilterEnabled) Gap(8.w),
        if (isWeekFilterEnabled) clearButton,
      ],
    );
  }
}
