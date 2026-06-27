import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AssignmentLevelSelector extends StatelessWidget {
  final AssignmentLevel? selectedLevel;
  final ValueChanged<AssignmentLevel> onLevelChanged;

  const AssignmentLevelSelector({super.key, required this.selectedLevel, required this.onLevelChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Assignment Level',
              style: context.textTheme.titleSmall?.copyWith(
                color: context.isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              ),
            ),
            Gap(4.w),
            Text('*', style: context.textTheme.titleSmall?.copyWith(color: AppColors.deleteIconRed)),
          ],
        ),
        Gap(12.h),
        _buildCards(context),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final departmentCard = _LevelCard(
      level: AssignmentLevel.department,
      title: 'Department Level',
      description: 'Assign to entire department',
      icon: Assets.icons.departmentIcon.path,
      isSelected: selectedLevel == AssignmentLevel.department,
      isCompact: isMobile,
      onTap: () => onLevelChanged(AssignmentLevel.department),
    );
    final employeeCard = _LevelCard(
      level: AssignmentLevel.employee,
      title: 'Employee Level',
      description: 'Assign to specific employee',
      icon: Assets.icons.addEmployeeIcon.path,
      isSelected: selectedLevel == AssignmentLevel.employee,
      isCompact: isMobile,
      onTap: () => onLevelChanged(AssignmentLevel.employee),
    );

    if (isMobile) {
      return Column(children: [departmentCard, Gap(10.h), employeeCard]);
    }
    return Row(
      children: [
        Expanded(child: departmentCard),
        Gap(16.w),
        Expanded(child: employeeCard),
      ],
    );
  }
}

class _LevelCard extends StatelessWidget {
  final AssignmentLevel level;
  final String title;
  final String description;
  final String icon;
  final bool isSelected;
  final bool isCompact;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.isCompact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(isCompact ? 12.w : 18.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.05))
              : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: isCompact ? _buildHorizontalContent(isDark) : _buildVerticalContent(isDark),
      ),
    );
  }

  Widget _buildVerticalContent(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildIconBox(isDark, size: 48.w, iconSize: 24),
        Gap(12.h),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(4.h),
        Text(
          description,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildHorizontalContent(bool isDark) {
    return Row(
      children: [
        _buildIconBox(isDark, size: 40.w, iconSize: 20),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(2.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (isSelected) ...[Gap(8.w), Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20.r)],
      ],
    );
  }

  Widget _buildIconBox(bool isDark, {required double size, required double iconSize}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : (isDark ? AppColors.inputBgDark : AppColors.inputBg),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: DigifyAsset(
          assetPath: icon,
          width: iconSize,
          height: iconSize,
          color: isSelected ? AppColors.primary : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
        ),
      ),
    );
  }
}
