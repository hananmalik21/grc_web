import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRoleCardMobile extends StatelessWidget with RolesManagementPermissionMixin {
  const DataRoleCardMobile({
    super.key,
    required this.role,
    required this.deleteIsLoading,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  final DataRoleItem role;
  final bool deleteIsLoading;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBackground = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final cardBorder = isDark
        ? AppColors.cardBorderDark.withValues(alpha: 0.8)
        : AppColors.cardBorder.withValues(alpha: 0.8);
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
                      assetPath: Assets.icons.focusAreaIcon.path,
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
                            DigifyStatusCapsule(status: role.isActive ? 'Active' : 'Inactive'),
                            if (role.dataType.isNotEmpty)
                              DigifySquareCapsule(
                                label: role.dataType,
                                backgroundColor: AppColors.infoBg,
                                textColor: AppColors.primary,
                                borderColor: AppColors.infoBorder,
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
                        if (role.createdBy != null)
                          DigifySquareCapsule(
                            label: role.createdBy!,
                            backgroundColor: AppColors.infoBg,
                            textColor: AppColors.roleActionBlue,
                            borderColor: AppColors.infoBorder,
                            borderRadius: BorderRadius.circular(7.r),
                            height: 28.h,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Gap(14.h),
              _ScopePreviewSection(
                title: 'Org Units',
                iconPath: Assets.icons.securityManager.hierarchy.path,
                items: role.orgUnits,
                isDark: isDark,
              ),
              Gap(12.h),
              _ScopePreviewSection(
                title: 'Positions',
                iconPath: Assets.icons.employeeListIcon.path,
                items: role.positions,
                isDark: isDark,
              ),
              Gap(12.h),
              _ScopePreviewSection(
                title: 'Grades',
                iconPath: Assets.icons.securityManager.database.path,
                items: role.grades,
                isDark: isDark,
              ),
              Gap(12.h),
              _ScopePreviewSection(
                title: 'Job Families',
                iconPath: Assets.icons.securityManager.functionalRoles.path,
                items: role.jobFamilies,
                isDark: isDark,
              ),
              Gap(12.h),
              _ScopePreviewSection(
                title: 'Job Levels',
                iconPath: Assets.icons.securityManager.dataRoles.path,
                items: role.jobLevels,
                isDark: isDark,
              ),
              Gap(16.h),
              DigifyDivider.horizontal(color: cardBorder),
              Gap(14.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (canUpdateRole) ...[
                    AppMobileButton(
                      svgPath: Assets.icons.editIconPurple.path,
                      backgroundColor: AppColors.editIconGreen,
                      onPressed: onEdit,
                    ),
                    Gap(8.w),
                  ],
                  if (canViewRole) ...[
                    AppMobileButton.primary(svgPath: Assets.icons.viewIconBlue.path, onPressed: onView),
                    Gap(8.w),
                  ],
                  AppMobileButton.outline(svgPath: Assets.icons.copyGray.path, onPressed: () => _handleCopy(context)),
                  if (canDeleteRole) ...[
                    Gap(8.w),
                    AppMobileButton.danger(
                      svgPath: Assets.icons.deleteIconRed.path,
                      isLoading: deleteIsLoading,
                      onPressed: onDelete,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCopy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: role.code));
    if (!context.mounted) return;
    ToastService.success(context, '${role.code} copied to clipboard', title: 'Copied');
  }
}

class _ScopePreviewSection extends StatelessWidget {
  const _ScopePreviewSection({required this.title, required this.iconPath, required this.items, required this.isDark});

  final String title;
  final String iconPath;
  final List<String> items;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final previewItems = items.take(3).toList();
    final remainingCount = items.length - previewItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(assetPath: iconPath, width: 15, height: 15, color: AppColors.primary),
            Gap(6.w),
            Text(
              '$title (${items.length})',
              style: context.textTheme.labelLarge?.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Gap(8.h),
        if (items.isEmpty)
          Text('No items assigned.', style: context.textTheme.bodySmall?.copyWith(color: secondaryText))
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final item in previewItems)
                DigifySquareCapsule(
                  label: item,
                  backgroundColor: AppColors.sidebarSearchBg,
                  textColor: secondaryText,
                  borderColor: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(7.r),
                  height: 28.h,
                ),
              if (remainingCount > 0)
                DigifySquareCapsule(
                  label: '+$remainingCount more',
                  backgroundColor: AppColors.infoBg,
                  textColor: AppColors.roleActionBlue,
                  borderColor: AppColors.infoBorder,
                  borderRadius: BorderRadius.circular(7.r),
                  height: 28.h,
                ),
            ],
          ),
      ],
    );
  }
}
