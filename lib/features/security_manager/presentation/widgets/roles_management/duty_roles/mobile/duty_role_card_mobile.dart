import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRoleCardMobile extends StatelessWidget with RolesManagementPermissionMixin {
  const DutyRoleCardMobile({
    super.key,
    required this.role,
    required this.deleteIsLoading,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final DutyRoleItem role;
  final bool deleteIsLoading;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBorder = isDark
        ? AppColors.cardBorderDark.withValues(alpha: 0.8)
        : AppColors.cardBorder.withValues(alpha: 0.8);
    final cardBackground = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canViewRole ? onView : null,
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: cardBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.05),
                blurRadius: 16,
                offset: const Offset(0, 6),
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
                    width: 46.w,
                    height: 46.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [AppColors.primary.withValues(alpha: 0.22), AppColors.primary.withValues(alpha: 0.08)]
                            : [AppColors.infoBg, AppColors.infoBg.withValues(alpha: 0.45)],
                      ),
                      borderRadius: BorderRadius.circular(13.r),
                      border: Border.all(color: AppColors.primary.withValues(alpha: isDark ? 0.28 : 0.12)),
                    ),
                    alignment: Alignment.center,
                    child: DigifyAsset(
                      assetPath: Assets.icons.industryIcon.path,
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
                            color: primaryText,
                          ),
                        ),
                        Gap(6.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            DigifyStatusCapsule(
                              status: role.isActive ? 'Active' : 'Inactive',
                              variant: DigifyStatusCapsuleVariant.rounded,
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                              borderRadius: 10.r,
                            ),
                            if (role.requiresApproval)
                              DigifySquareCapsule(
                                label: 'Approval Required',
                                backgroundColor: AppColors.approvalRequiredBg,
                                textColor: AppColors.approvalRequiredText,
                                borderColor: AppColors.cardBorder,
                                borderRadius: BorderRadius.circular(8.r),
                                height: 28.h,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Gap(14.h),
              Text(
                role.description.isEmpty ? 'No description provided.' : role.description,
                style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, height: 1.45, color: secondaryText),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(14.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark.withValues(alpha: 0.35)
                      : AppColors.cardBackgroundGrey.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        DigifySquareCapsule(
                          label: role.code,
                          backgroundColor: AppColors.sidebarSearchBg,
                          textColor: secondaryText,
                          borderColor: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(7.r),
                          height: 28.h,
                        ),
                        DigifySquareCapsule(
                          label: role.category,
                          backgroundColor: role.categoryBackgroundColor ?? AppColors.infoBg,
                          textColor: role.categoryTextColor ?? AppColors.roleActionBlue,
                          borderColor: role.categoryBorderColor ?? AppColors.infoBorder,
                          borderRadius: BorderRadius.circular(7.r),
                          height: 28.h,
                        ),
                      ],
                    ),
                    Gap(10.h),
                    Row(
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.employeeListIcon.path,
                          width: 15,
                          height: 15,
                          color: secondaryText,
                        ),
                        Gap(6.w),
                        Expanded(
                          child: Text(
                            role.usersAssignedLabel.isEmpty ? 'No users assigned' : role.usersAssignedLabel,
                            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: secondaryText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(14.h),
              _FunctionRolePreview(items: role.includedFunctionRoles, isDark: isDark),
              Gap(16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (canUpdateRole) ...[
                    AppMobileButton(
                      svgPath: Assets.icons.editIconGreen.path,
                      type: AppButtonType.outline,
                      backgroundColor: AppColors.editIconGreen.withValues(alpha: 0.1),
                      foregroundColor: AppColors.editIconGreen,
                      borderColor: AppColors.editIconGreen.withValues(alpha: 0.25),
                      onPressed: onEdit,
                    ),
                    Gap(8.w),
                  ],
                  if (canViewRole) ...[
                    AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView),
                    Gap(8.w),
                  ],
                  if (canDeleteRole)
                    AppMobileButton.danger(
                      svgPath: Assets.icons.deleteIconRed.path,
                      isLoading: deleteIsLoading,
                      onPressed: onDelete,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FunctionRolePreview extends StatelessWidget {
  const _FunctionRolePreview({required this.items, required this.isDark});

  final List<String> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final previewItems = items.take(3).toList();
    final remainingCount = items.length - previewItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(
              assetPath: Assets.icons.securityManager.functionalRoles.path,
              width: 15,
              height: 15,
              color: AppColors.primary,
            ),
            Gap(6.w),
            Text(
              'Function Roles (${items.length})',
              style: context.textTheme.labelLarge?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ],
        ),
        Gap(8.h),
        if (items.isEmpty)
          Text(
            'No function roles assigned',
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: secondary),
          )
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final item in previewItems)
                DigifySquareCapsule(
                  label: item,
                  backgroundColor: AppColors.infoBg,
                  textColor: AppColors.primary,
                  borderColor: AppColors.infoBorder,
                  borderRadius: BorderRadius.circular(7.r),
                  height: 28.h,
                ),
              if (remainingCount > 0)
                DigifySquareCapsule(
                  label: '+$remainingCount more',
                  backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                  textColor: secondary,
                  borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(7.r),
                  height: 28.h,
                ),
            ],
          ),
      ],
    );
  }
}
