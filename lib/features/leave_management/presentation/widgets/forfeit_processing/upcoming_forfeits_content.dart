import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_schedule_entry.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpcomingForfeitsContent extends StatelessWidget {
  final List<ForfeitScheduleEntry> scheduleEntries;
  final ForfeitScheduleEntry? selectedEntry;
  final bool isDark;
  final ValueChanged<ForfeitScheduleEntry>? onEntrySelected;

  const UpcomingForfeitsContent({
    super.key,
    required this.scheduleEntries,
    this.selectedEntry,
    required this.isDark,
    this.onEntrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.leaveManagement.emptyLeave.path,
                width: 20,
                height: 20,
                color: AppColors.primary,
              ),
              Gap(7.w),
              Text(
                'Upcoming Forfeit Schedule',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(14.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: scheduleEntries.map((entry) {
              return _ForfeitScheduleEntryItem(
                entry: entry,
                isSelected: selectedEntry?.id == entry.id,
                isDark: isDark,
                onTap: onEntrySelected != null ? () => onEntrySelected!(entry) : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ForfeitScheduleEntryItem extends StatelessWidget {
  final ForfeitScheduleEntry entry;
  final bool isSelected;
  final bool isDark;
  final VoidCallback? onTap;

  const _ForfeitScheduleEntryItem({required this.entry, required this.isSelected, required this.isDark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? (isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.infoBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final borderColor = isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.3) : AppColors.infoBg,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: DigifyAsset(
                  assetPath: Assets.icons.leaveManagement.emptyLeave.path,
                  width: 20,
                  height: 20,
                  color: AppColors.primary,
                ),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.h,
                children: [
                  Text(
                    entry.monthYear,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${entry.employeeCount} employees • ${entry.totalDays} days',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            DigifyCapsule(
              label: entry.status == ForfeitScheduleStatus.readyToProcess ? 'Ready to Process' : 'Scheduled',
              backgroundColor: isDark ? AppColors.jobRoleBg.withValues(alpha: 0.3) : AppColors.jobRoleBg,
              textColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
