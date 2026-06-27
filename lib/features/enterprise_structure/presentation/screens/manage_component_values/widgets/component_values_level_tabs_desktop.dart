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

class ComponentValuesLevelTabsDesktop extends StatelessWidget {
  const ComponentValuesLevelTabsDesktop({
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
      padding: EdgeInsetsDirectional.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Row(
          children: [
            Expanded(
              child: _LevelTabChip(
                label: treeViewLabel,
                iconPath: treeViewIconPath,
                isActive: isTreeViewActive,
                isDark: isDark,
                onTap: onTreeViewTap,
              ),
            ),
            for (final level in levels) ...[
              Gap(8.w),
              Expanded(
                child: _LevelTabChip(
                  key: Key('tab_${level.levelCode}'),
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

class _LevelTabChip extends StatelessWidget {
  const _LevelTabChip({
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(
                assetPath: iconPath,
                width: 16,
                height: 16,
                color: isActive ? AppColors.dashboardCard : AppColors.textSecondary,
              ),
              Gap(8.w),
              Flexible(
                child: Text(
                  label,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isActive ? AppColors.dashboardCard : AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
