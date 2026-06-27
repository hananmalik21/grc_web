import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_switch.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HierarchyLevelCard extends StatelessWidget {
  final String name;
  final String icon;
  final int levelNumber;
  final bool isMandatory;
  final bool isActive;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;
  final ValueChanged<bool>? onToggleActive;
  final bool showArrows;
  final EdgeInsetsGeometry? capsulePadding;

  const HierarchyLevelCard({
    super.key,
    required this.name,
    required this.icon,
    required this.levelNumber,
    required this.isMandatory,
    required this.isActive,
    required this.canMoveUp,
    required this.canMoveDown,
    this.onMoveUp,
    this.onMoveDown,
    this.onToggleActive,
    this.showArrows = true,
    this.capsulePadding,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final effectiveCapsulePadding = capsulePadding ?? EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h);

    return Container(
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark : AppColors.infoBg,
        border: Border.all(color: AppColors.ingobgBorder, width: 2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          _buildIcon(isDark),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8.w,
                  runSpacing: 4.h,
                  children: [
                    Text(
                      name,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontSize: 16.sp,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    if (isMandatory)
                      DigifySquareCapsule(
                        label: localizations.mandatory,
                        backgroundColor: isDark ? AppColors.errorBgDark : AppColors.errorBg,
                        textColor: isDark ? AppColors.errorTextDark : AppColors.errorText,
                        borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
                        padding: effectiveCapsulePadding,
                      ),
                    DigifySquareCapsule(
                      label: localizations.active,
                      backgroundColor: isDark ? AppColors.successBgDark : AppColors.successBg,
                      textColor: isDark ? AppColors.successTextDark : AppColors.successText,
                      borderColor: isDark ? AppColors.successBorderDark : AppColors.successBorder,
                      padding: effectiveCapsulePadding,
                    ),
                  ],
                ),
                Gap(2.h),
                Text(
                  'Level $levelNumber in the hierarchy',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (showArrows) ...[
            Gap(8.w),
            _ArrowButtons(
              isDark: isDark,
              canMoveUp: canMoveUp,
              canMoveDown: canMoveDown,
              onMoveUp: onMoveUp,
              onMoveDown: onMoveDown,
            ),
            Gap(14.w),
          ] else ...[
            Gap(8.w),
          ],
          DigifySwitch(value: isActive, onChanged: isMandatory ? null : onToggleActive),
        ],
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10.r)),
      alignment: Alignment.center,
      child: DigifyAsset(assetPath: icon, width: 24, height: 24, color: AppColors.cardBackground),
    );
  }
}

class _ArrowButtons extends StatelessWidget {
  final bool isDark;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  const _ArrowButtons({
    required this.isDark,
    required this.canMoveUp,
    required this.canMoveDown,
    this.onMoveUp,
    this.onMoveDown,
  });

  Color _arrowColor(bool enabled) => enabled
      ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary)
      : (isDark ? AppColors.textTertiaryDark : AppColors.textTertiary);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.enterpriseStructure.upArrow.path,
          onTap: canMoveUp ? onMoveUp : null,
          width: 16,
          height: 16,
          color: _arrowColor(canMoveUp),
          padding: 4.w,
        ),
        Gap(4.h),
        DigifyAssetButton(
          assetPath: Assets.icons.enterpriseStructure.downArrow.path,
          onTap: canMoveDown ? onMoveDown : null,
          width: 16,
          height: 16,
          color: _arrowColor(canMoveDown),
          padding: 4.w,
        ),
      ],
    );
  }
}
