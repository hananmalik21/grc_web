import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationRoleCardMobile extends StatelessWidget with RolesManagementPermissionMixin {
  const ApplicationRoleCardMobile({super.key, required this.role, required this.onView, this.onEdit, this.onDelete});

  final ApplicationRoleItem role;
  final VoidCallback onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [AppColors.primary.withValues(alpha: 0.2), AppColors.primary.withValues(alpha: 0.1)]
                            : [AppColors.infoBg, AppColors.infoBg.withValues(alpha: 0.5)],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.primary.withValues(alpha: isDark ? 0.3 : 0.1)),
                    ),
                    alignment: Alignment.center,
                    child: DigifyAsset(
                      assetPath: Assets.icons.securityIcon.path,
                      width: 22,
                      height: 22,
                      color: AppColors.primary,
                    ),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role.name,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          ),
                        ),
                        Gap(4.h),
                        DigifyStatusCapsule(status: role.isActive ? 'Active' : 'Inactive'),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(14.h),
              Text(
                role.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  height: 1.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withValues(alpha: 0.3)
                      : AppColors.background.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _MetaItem(iconPath: Assets.icons.usersIcon.path, text: role.usersLabel),
                        ),
                        Expanded(
                          child: _MetaItem(iconPath: Assets.icons.descriptionIcon.path, text: role.category),
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Row(
                      children: [
                        Expanded(
                          child: _MetaItem(iconPath: Assets.icons.clockIcon.path, text: role.updatedAt),
                        ),
                        Expanded(
                          child: _MetaItem(iconPath: Assets.icons.userIcon.path, text: role.createdBy),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (canUpdateRole) ...[
                    AppMobileButton(
                      svgPath: Assets.icons.editIconGreen.path,
                      backgroundColor: AppColors.editIconGreen.withValues(alpha: 0.1),
                      foregroundColor: AppColors.editIconGreen,
                      type: AppButtonType.secondary,
                      onPressed: onEdit,
                    ),
                    Gap(8.w),
                  ],
                  if (canDeleteRole) ...[
                    AppMobileButton(
                      svgPath: Assets.icons.deleteIconRed.path,
                      backgroundColor: AppColors.error.withValues(alpha: 0.1),
                      foregroundColor: AppColors.error,
                      onPressed: onDelete,
                    ),
                    Gap(8.w),
                  ],
                  if (canViewRole) AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({required this.iconPath, required this.text});
  final String iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
            shape: BoxShape.circle,
          ),
          child: DigifyAsset(
            assetPath: iconPath,
            width: 12,
            height: 12,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        Gap(8.w),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 11.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
