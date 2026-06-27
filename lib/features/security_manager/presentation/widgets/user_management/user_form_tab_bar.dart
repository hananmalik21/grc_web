import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';

class UserFormTabBar extends StatelessWidget implements PreferredSizeWidget {
  const UserFormTabBar({
    super.key,
    required this.controller,
    required this.isDark,
  });

  final TabController controller;
  final bool isDark;

  @override
  Size get preferredSize => Size.fromHeight(48.h);

  @override
  Widget build(BuildContext context) {
    final unselectedColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: [
          _buildTab(
            context: context,
            iconPath: 'assets/icons/user_icon.svg',
            label: 'Account Information',
            unselectedColor: unselectedColor,
          ),
          _buildTab(
            context: context,
            iconPath: 'assets/icons/leadership_icon.svg',
            label: 'Roles & Responsibilities',
            unselectedColor: unselectedColor,
          ),
          _buildTab(
            context: context,
            iconPath: 'assets/icons/lock_icon.svg',
            label: 'Access & Permissions',
            unselectedColor: unselectedColor,
          ),
          _buildTab(
            context: context,
            iconPath: 'assets/icons/settings_icon.svg',
            label: 'User Preferences',
            unselectedColor: unselectedColor,
          ),
          _buildTab(
            context: context,
            iconPath: 'assets/icons/security_icon.svg',
            label: 'Security Settings',
            unselectedColor: unselectedColor,
          ),
        ],
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2.w, color: AppColors.primary),
          ),
          color: AppColors.primary.withValues(alpha: .05),
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.primary,
        unselectedLabelColor: unselectedColor,
        labelStyle: context.textTheme.titleSmall?.copyWith(
          color: AppColors.primary,
        ),
        unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
          color: unselectedColor,
        ),
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required String iconPath,
    required String label,
    required Color unselectedColor,
  }) {
    return Tab(
      child: Builder(
        builder: (context) {
          final color =
              DefaultTextStyle.of(context).style.color ?? unselectedColor;
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DigifyAsset(
                assetPath: iconPath,
                width: 18.w,
                height: 18.h,
                color: color,
              ),
              Gap(8.w),
              Text(label),
            ],
          );
        },
      ),
    );
  }
}
