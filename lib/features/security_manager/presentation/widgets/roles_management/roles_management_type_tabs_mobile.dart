import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Horizontally scrollable role-type chips for narrow layouts (mobile / small tablet).
class RolesManagementTypeTabsMobile extends StatelessWidget {
  const RolesManagementTypeTabsMobile({super.key, required this.selectedType, required this.onTypeSelected});

  final String selectedType;
  final ValueChanged<RoleTabType> onTypeSelected;

  RoleTabType _resolveSelectedTab() {
    for (final tab in RolesManagementNotifier.roleTabs) {
      if (tab.label == selectedType) return tab;
    }
    return RolesManagementNotifier.roleTabs.first;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final selectedTab = _resolveSelectedTab();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            clipBehavior: Clip.none,
            child: Row(
              children: [
                for (var i = 0; i < RolesManagementNotifier.roleTabs.length; i++) ...[
                  if (i > 0) Gap(8.w),
                  _MobileRoleTypeChip(
                    tab: RolesManagementNotifier.roleTabs[i],
                    isSelected: selectedType == RolesManagementNotifier.roleTabs[i].label,
                    isDark: isDark,
                    onTap: () => onTypeSelected(RolesManagementNotifier.roleTabs[i]),
                  ),
                ],
              ],
            ),
          ),
          Gap(12.h),
          Text(
            selectedTab.tabSubtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileRoleTypeChip extends StatelessWidget {
  const _MobileRoleTypeChip({required this.tab, required this.isSelected, required this.isDark, required this.onTap});

  final RoleTabType tab;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.primary
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final textColor = isSelected
        ? AppColors.buttonTextLight
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: isSelected
                ? null
                : Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 152.w),
            child: Text(
              tab.tabTitle,
              style: context.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
