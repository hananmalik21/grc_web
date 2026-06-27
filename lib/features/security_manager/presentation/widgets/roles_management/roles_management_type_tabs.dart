import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RolesManagementTypeTabs extends StatelessWidget {
  const RolesManagementTypeTabs({super.key, required this.selectedType, required this.onTypeSelected});

  final String selectedType;
  final ValueChanged<RoleTabType> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          for (int index = 0; index < RolesManagementNotifier.roleTabs.length; index++) ...[
            Expanded(
              child: _TypeTabButton(
                isSelected: selectedType == RolesManagementNotifier.roleTabs[index].label,
                title: RolesManagementNotifier.roleTabs[index].tabTitle,
                subtitle: RolesManagementNotifier.roleTabs[index].tabSubtitle,
                onTap: () => onTypeSelected(RolesManagementNotifier.roleTabs[index]),
              ),
            ),
            if (index != RolesManagementNotifier.roleTabs.length - 1) Gap(8.w),
          ],
        ],
      ),
    );
  }
}

class _TypeTabButton extends StatelessWidget {
  const _TypeTabButton({required this.isSelected, required this.title, required this.subtitle, required this.onTap});

  final bool isSelected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final selectedColor = AppColors.primary;
    final unselectedColor = isDark ? AppColors.blackTextColor : AppColors.textSecondary;
    final subtitleColor = AppColors.textPlaceholder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(
              bottom: BorderSide(color: isSelected ? selectedColor : Colors.transparent, width: 2.w),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              Gap(2.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
