import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_level_tabs_desktop.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/widgets/component_values_level_tabs_mobile.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/active_levels_provider.dart'
    show manageComponentValuesActiveLevelsProvider;
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComponentValuesLevelTabs extends ConsumerWidget {
  const ComponentValuesLevelTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLevelsState = ref.watch(manageComponentValuesActiveLevelsProvider);
    final screenState = ref.watch(manageComponentValuesScreenProvider);
    final screenNotifier = ref.read(manageComponentValuesScreenProvider.notifier);

    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);

    final levelsError = activeLevelsState.errorMessage;
    final isLevelsLoading = activeLevelsState.isLoading;
    final isTreeViewActive = screenState.isTreeView;
    final selectedLevel = screenState.selectedLevel;

    if (levelsError != null) {
      return Container(
        padding: EdgeInsetsDirectional.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            levelsError,
            style: TextStyle(fontSize: 14.sp, color: Colors.red),
          ),
        ),
      );
    }

    final displayLevels = isLevelsLoading
        ? List.generate(
            5,
            (index) => ActiveStructureLevel(
              levelId: index,
              structureId: '0',
              levelNumber: index + 1,
              levelCode: 'level_$index',
              levelName: 'Loading Level',
              isMandatory: false,
              isActive: true,
              displayOrder: index,
            ),
          )
        : activeLevelsState.levels;

    final treeViewIconPath = isTreeViewActive ? Assets.icons.treeViewIconActive.path : Assets.icons.treeViewIcon.path;

    if (isMobile) {
      return Skeletonizer(
        enabled: isLevelsLoading,
        child: ComponentValuesLevelTabsMobile(
          treeViewLabel: localizations.treeView,
          treeViewIconPath: treeViewIconPath,
          isTreeViewActive: isTreeViewActive,
          isDark: isDark,
          onTreeViewTap: screenNotifier.selectTreeView,
          levels: displayLevels,
          selectedLevel: selectedLevel,
          onLevelTap: screenNotifier.selectLevel,
        ),
      );
    }

    return Skeletonizer(
      enabled: isLevelsLoading,
      child: ComponentValuesLevelTabsDesktop(
        treeViewLabel: localizations.treeView,
        treeViewIconPath: treeViewIconPath,
        isTreeViewActive: isTreeViewActive,
        isDark: isDark,
        onTreeViewTap: screenNotifier.selectTreeView,
        levels: displayLevels,
        selectedLevel: selectedLevel,
        onLevelTap: screenNotifier.selectLevel,
      ),
    );
  }
}
