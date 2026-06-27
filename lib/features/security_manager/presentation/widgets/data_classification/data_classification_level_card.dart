import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/security_manager/presentation/providers/data_classification/data_classification_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataClassificationLevelCard extends StatelessWidget {
  final DataClassificationLevel level;
  final bool isDark;

  const DataClassificationLevelCard({super.key, required this.level, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: level.type.iconPath,
              width: 18,
              height: 18,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
            ),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      level.type.label,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Gap(10.w),
                    DigifySquareCapsule(
                      label: '${level.fieldsCount} Fields',
                      backgroundColor: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.jobRoleBg,
                      textColor: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  ],
                ),
                Gap(7.h),
                Text(
                  level.type.subtitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(14.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.securityManager.database.path,
                      width: 14,
                      height: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    Gap(6.w),
                    Text(
                      'Protected Fields',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Gap(7.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final field in level.protectedFields)
                      DigifySquareCapsule(
                        label: field,
                        backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                        borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                        textColor: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                  ],
                ),
                Gap(14.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DigifyAsset(
                      assetPath: Assets.icons.usersIcon.path,
                      width: 14,
                      height: 14,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                    Gap(6.w),
                    Text(
                      'Access Roles',
                      style: context.textTheme.headlineMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Gap(8.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    for (final role in level.accessRoles)
                      DigifySquareCapsule(
                        label: role,
                        backgroundColor: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.jobRoleBg,
                        textColor: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Gap(14.w),
          Column(
            children: [
              AppButton(
                label: 'Edit',
                type: AppButtonType.outline,
                svgPath: Assets.icons.editIcon.path,
                height: 34,
                width: 100,
                fontSize: 12.sp,
                backgroundColor: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.jobRoleBg,
                foregroundColor: AppColors.primary,
                borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
                onPressed: () => ToastService.info(context, 'Edit ${level.type.label} classification (mock).'),
              ),
              Gap(8.h),
              AppButton(
                label: 'Delete',
                type: AppButtonType.outline,
                svgPath: Assets.icons.deleteIconRed.path,
                height: 34,
                width: 100,
                fontSize: 12.sp,
                backgroundColor: isDark ? AppColors.errorBgDark.withValues(alpha: 0.2) : AppColors.redBg,
                foregroundColor: AppColors.error,
                borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
                onPressed: () async {
                  final confirmed = await AppConfirmationDialog.show(
                    context,
                    title: 'Delete Classification',
                    message: 'Are you sure you want to delete this classification?',
                    confirmLabel: 'Delete',
                    type: ConfirmationType.danger,
                    svgPath: Assets.icons.deleteIconRed.path,
                  );

                  if (confirmed != true) return;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
