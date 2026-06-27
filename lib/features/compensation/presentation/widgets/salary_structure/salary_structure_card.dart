import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/action_button.dart';
import 'package:grc/core/widgets/buttons/icon_action_button.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/salary_structure_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryStructureCard extends StatelessWidget {
  final SalaryStructureItem item;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const SalaryStructureCard({
    super.key,
    required this.item,
    required this.onView,
    required this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: DigifyAsset(
                    assetPath: Assets.icons.buildingSmallIcon.path,
                    width: 30.w,
                    height: 30.w,
                    color: AppColors.primary,
                  ),
                ),
                Gap(14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.uiName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      Gap(6.h),
                      Text(
                        item.uiCode,
                        style: context.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(12.w),
                DigifyStatusCapsule(status: item.uiStatus),
              ],
            ),
            Gap(28.h),
            _InfoRow(iconAssetPath: Assets.icons.clockIcon.path, text: 'Modified: ${item.uiModifiedDate}'),
            Gap(14.h),
            _InfoRow(iconAssetPath: Assets.icons.compensation.fileList.path, text: item.uiType),
            Gap(14.h),
            _InfoRow(iconAssetPath: Assets.icons.buildingSmallIcon.path, text: item.uiLocation),
            Gap(24.h),
            Container(
              padding: EdgeInsets.only(top: 18.h),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder)),
              ),
              child: _SalaryStructureCardActions(
                onView: onView,
                onEdit: onEdit,
                onDelete: onDelete,
                isDeleting: isDeleting,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String iconAssetPath;
  final String text;

  const _InfoRow({required this.iconAssetPath, required this.text});

  @override
  Widget build(BuildContext context) {
    final color = context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Row(
      children: [
        DigifyAsset(assetPath: iconAssetPath, width: 22.w, height: 22.w, color: color),
        Gap(12.w),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400, color: color),
          ),
        ),
      ],
    );
  }
}

class _SalaryStructureCardActions extends StatelessWidget with SalaryStructurePermissionMixin {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const _SalaryStructureCardActions({
    required this.onView,
    required this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (canViewSalaryStructure)
          Expanded(
            child: ActionButton(
              label: localizations.view,
              onTap: onView,
              iconPath: Assets.icons.viewIconBlue.path,
              backgroundColor: AppColors.infoBg,
              foregroundColor: AppColors.primary,
            ),
          ),
        if (canUpdateSalaryStructure) ...[
          Gap(8.w),
          Expanded(
            child: ActionButton(
              label: localizations.edit,
              onTap: onEdit,
              iconPath: Assets.icons.editIconGreen.path,
              backgroundColor: AppColors.greenBg,
              foregroundColor: AppColors.greenButton,
            ),
          ),
        ],
        if (canDeleteSalaryStructure) ...[
          Gap(8.w),
          IconActionButton(
            iconPath: Assets.icons.deleteIconRed.path,
            bgColor: AppColors.errorBg,
            iconColor: AppColors.error,
            onPressed: isDeleting ? null : onDelete,
            isLoading: isDeleting,
          ),
        ],
      ],
    );
  }
}
