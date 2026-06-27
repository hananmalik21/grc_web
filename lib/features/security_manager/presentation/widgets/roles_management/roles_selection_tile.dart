import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RolesSelectionTile extends StatelessWidget {
  const RolesSelectionTile({
    super.key,
    this.title,
    this.code,
    this.moduleName,
    this.isActive = false,
    this.isSelected = false,
    this.onTap,
    this.showCheckbox = true,
    this.showActiveBadge = true,
    this.leadingIconPath,
    this.activeLabel = 'Active',
  });

  final String? title;
  final String? code;
  final String? moduleName;
  final bool isActive;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showCheckbox;
  final bool showActiveBadge;
  final String? leadingIconPath;
  final String activeLabel;

  @override
  Widget build(BuildContext context) {
    final resolvedTitle = title?.trim().isNotEmpty == true
        ? title!.trim()
        : code?.trim().isNotEmpty == true
        ? code!.trim()
        : moduleName?.trim().isNotEmpty == true
        ? moduleName!.trim()
        : 'Unnamed role';

    final metadata = <Widget>[
      if (code?.trim().isNotEmpty == true) _MetaChip(title: 'Code:', label: code!.trim()),
      if (moduleName?.trim().isNotEmpty == true) _MetaChip(title: 'Module:', label: moduleName!.trim()),
    ];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.infoBg : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? AppColors.infoBorder : AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showCheckbox) ...[
              DigifyCheckbox(value: isSelected, onChanged: onTap == null ? null : (_) => onTap!()),
              Gap(12.w),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      DigifyAsset(
                        assetPath: leadingIconPath ?? Assets.icons.securityManager.functionalRoles.path,
                        width: 18,
                        height: 18,
                        color: AppColors.primary,
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Text(
                          resolvedTitle,
                          style: context.textTheme.titleSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showActiveBadge && isActive) DigifyStatusCapsule(status: activeLabel),
                    ],
                  ),
                  if (metadata.isNotEmpty) ...[
                    Gap(4.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 3.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: metadata,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.title, required this.label});

  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: context.textTheme.labelMedium?.copyWith(color: AppColors.textSecondary)),
        Gap(3.w),
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 11.sp),
        ),
      ],
    );
  }
}
