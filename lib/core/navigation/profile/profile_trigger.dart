import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileTrigger extends StatelessWidget {
  const ProfileTrigger({
    super.key,
    required this.isDark,
    required this.layout,
    required this.avatarSize,
    required this.avatarIconSize,
    required this.name,
    required this.role,
  });

  final bool isDark;
  final ScreenLayout layout;
  final double avatarSize;
  final double avatarIconSize;
  final String name;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.employeeManagement.user.path,
            width: avatarIconSize,
            height: avatarIconSize,
            color: AppColors.cardBackground,
          ),
        ),
        if (layout.isDesktop) ...[
          Gap(layout.isTabletMedium ? 5.w : 7.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: context.textTheme.headlineMedium?.copyWith(
                  fontSize: layout.isTabletMedium ? 11.sp : 12.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Text(
                role,
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: layout.isTabletMedium ? 9.sp : 10.sp,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.tableHeaderText,
                ),
              ),
            ],
          ),
          Gap(layout.isTabletMedium ? 8.w : 12.w),
          DigifyAsset(
            assetPath: Assets.icons.header.chevronDown.path,
            height: layout.isTabletMedium ? 12.sp : 14.sp,
            width: layout.isTabletMedium ? 12.sp : 14.sp,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textPlaceholderDark,
          ),
        ],
      ],
    );
  }
}
