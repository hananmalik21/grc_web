import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/data/config/leave_management_tabs_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LeaveManagementTabBar extends StatelessWidget {
  final AppLocalizations localizations;
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;
  final bool isDark;

  const LeaveManagementTabBar({
    super.key,
    required this.localizations,
    required this.selectedTabIndex,
    required this.onTabSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = LeaveManagementTabsConfig.getTabs();

    return Container(
      padding: EdgeInsets.all(4.w),
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final label = LeaveManagementTabsConfig.getLocalizedLabel(tab.labelKey, localizations);
            final isSelected = selectedTabIndex == index;
            return Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: _buildTabButton(
                context: context,
                label: label,
                icon: tab.iconPath,
                isSelected: isSelected,
                onTap: () => onTabSelected(index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String label,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: icon,
                width: 16,
                height: 16,
                color: isSelected ? AppColors.dashboardCard : AppColors.textSecondary,
              ),
              Gap(8.w),
              Text(
                label,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isSelected ? AppColors.dashboardCard : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
