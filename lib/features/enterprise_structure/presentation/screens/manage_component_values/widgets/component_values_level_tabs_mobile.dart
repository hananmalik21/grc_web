import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentValuesLevelTabsMobile extends StatelessWidget {
  const ComponentValuesLevelTabsMobile({
    super.key,
    required this.treeViewLabel,
    required this.treeViewIconPath,
    required this.isTreeViewActive,
    required this.isDark,
    required this.onTreeViewTap,
    required this.levels,
    required this.selectedLevel,
    required this.onLevelTap,
  });

  final String treeViewLabel;
  final String treeViewIconPath;
  final bool isTreeViewActive;
  final bool isDark;
  final VoidCallback onTreeViewTap;
  final List<ActiveStructureLevel> levels;
  final OrganizationLevel? selectedLevel;
  final void Function(ActiveStructureLevel) onLevelTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Row(
          children: [
            Expanded(
              child: _MobileLevelTabItem(
                label: treeViewLabel,
                iconPath: treeViewIconPath,
                isActive: isTreeViewActive,
                isDark: isDark,
                onTap: onTreeViewTap,
              ),
            ),
            for (final level in levels) ...[
              Gap(6.w),
              Expanded(
                child: _MobileLevelTabItem(
                  key: Key('mobile_tab_${level.levelCode}'),
                  label: level.levelName,
                  iconPath: getIconsForLevelCode(level.levelCode)['icon'] ?? Assets.icons.companyIcon.path,
                  isActive: selectedLevel?.code == level.levelCode,
                  isDark: isDark,
                  onTap: () => onLevelTap(level),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MobileLevelTabItem extends StatelessWidget {
  const _MobileLevelTabItem({
    super.key,
    required this.label,
    required this.iconPath,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.textMutedDark : AppColors.textMuted;
    final activeBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.35) : AppColors.infoBg;
    final color = isActive ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: EdgeInsetsDirectional.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyAsset(assetPath: iconPath, width: 22, height: 22, color: color),
            Gap(4.h),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
              child: Text(
                label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 10.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Gap(6.h),
            AnimatedOpacity(
              opacity: isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 180),
              child: Container(
                height: 2.5.h,
                width: 24.w,
                decoration: BoxDecoration(color: activeColor, borderRadius: BorderRadius.circular(2.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
