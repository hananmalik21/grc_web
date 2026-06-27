import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'roles_management_surface_card.dart';

class RolesManagementActivityLogCard extends StatelessWidget {
  const RolesManagementActivityLogCard({super.key, required this.activities});

  final List<RoleActivity> activities;

  @override
  Widget build(BuildContext context) {
    return RolesManagementSectionCard(
      title: 'Activity Log',
      subtitle: 'Recent changes for this role',
      child: Column(
        children: [
          for (int index = 0; index < activities.length; index++)
            Padding(
              padding: EdgeInsets.only(bottom: index == activities.length - 1 ? 0 : 8.h),
              child: _ActivityTimelineTile(activity: activities[index], isLast: index == activities.length - 1),
            ),
        ],
      ),
    );
  }
}

class _ActivityTimelineTile extends StatelessWidget {
  const _ActivityTimelineTile({required this.activity, required this.isLast});

  final RoleActivity activity;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 34.w,
          child: Column(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: BoxDecoration(color: _iconBackground(activity.iconKey), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: _iconPath(activity.iconKey),
                  width: 14,
                  height: 14,
                  color: _iconColor(activity.iconKey),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2.w,
                  height: 58.h,
                  color: context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                ),
            ],
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(2.h),
                Text(
                  activity.description,
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.sidebarCategoryText,
                  ),
                ),
                Gap(6.h),
                Text(
                  activity.relativeTime,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _iconPath(String iconKey) => switch (iconKey) {
    'users' => Assets.icons.employeesBlueIcon.path,
    'warning' => Assets.icons.warningIcon.path,
    'copy' => Assets.icons.copyGray.path,
    'create' => Assets.icons.addEmployeeIcon.path,
    _ => Assets.icons.editIconGreen.path,
  };

  Color _iconBackground(String iconKey) => switch (iconKey) {
    'warning' => AppColors.orangeBg,
    _ => AppColors.infoBg,
  };

  Color _iconColor(String iconKey) => switch (iconKey) {
    'warning' => AppColors.orange,
    _ => AppColors.primary,
  };
}
