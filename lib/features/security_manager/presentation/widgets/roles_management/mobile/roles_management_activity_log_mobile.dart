import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../roles_management_surface_card.dart';

class RolesManagementActivityLogMobile extends StatelessWidget {
  const RolesManagementActivityLogMobile({super.key, required this.activities});

  final List<RoleActivity> activities;

  @override
  Widget build(BuildContext context) {
    return RolesManagementSectionCard(
      title: 'Activity Log',
      subtitle: 'Recent changes for this role',
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return _ActivityTimelineMobileTile(activity: activities[index], isLast: index == activities.length - 1);
        },
      ),
    );
  }
}

class _ActivityTimelineMobileTile extends StatelessWidget {
  const _ActivityTimelineMobileTile({required this.activity, required this.isLast});

  final RoleActivity activity;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.w,
            child: Column(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(color: _iconBackground(activity.iconKey), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: DigifyAsset(
                    assetPath: _iconPath(activity.iconKey),
                    width: 14.w,
                    height: 14.w,
                    color: _iconColor(activity.iconKey),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.5.w,
                      color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                    ),
                  ),
              ],
            ),
          ),
          Gap(12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    activity.description,
                    style: context.textTheme.labelSmall?.copyWith(
                      fontSize: 12.sp,
                      height: 1.4,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  Gap(6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 12.sp,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                      ),
                      Gap(4.w),
                      Text(
                        activity.relativeTime,
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
