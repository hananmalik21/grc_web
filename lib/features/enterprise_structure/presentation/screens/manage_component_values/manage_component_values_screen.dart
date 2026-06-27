import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_screen_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_body.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_permission_mixin.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_desktop_layout.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_mobile_layout.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/active_levels_provider.dart'
    show manageComponentValuesActiveLevelsProvider;

class ManageComponentValuesScreen extends ConsumerStatefulWidget {
  final String? initialLevelCode;

  const ManageComponentValuesScreen({super.key, this.initialLevelCode});

  @override
  ConsumerState<ManageComponentValuesScreen> createState() => _ManageComponentValuesScreenState();
}

class _ManageComponentValuesScreenState extends ConsumerState<ManageComponentValuesScreen>
    with ManageComponentValuesPermissionMixin {
  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(manageComponentValuesSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewComponentValue) return AppUnauthorizedState();

    final initialCode = widget.initialLevelCode?.trim();
    if (initialCode != null && initialCode.isNotEmpty) {
      final activeLevelsState = ref.watch(manageComponentValuesActiveLevelsProvider);
      final screenState = ref.watch(manageComponentValuesScreenProvider);

      final desiredCode = initialCode.toUpperCase();
      final isAlreadySelected = !screenState.isTreeView && screenState.selectedLevelCode.toUpperCase() == desiredCode;

      if (!activeLevelsState.isLoading && activeLevelsState.levels.isNotEmpty && !isAlreadySelected) {
        ActiveStructureLevel? level;
        for (final item in activeLevelsState.levels) {
          if (item.levelCode.toUpperCase() == desiredCode) {
            level = item;
            break;
          }
        }
        if (level != null) {
          final selectedLevel = level;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(manageComponentValuesScreenProvider.notifier).selectLevel(selectedLevel);
          });
        }
      }
    }

    final selectedEnterpriseId = ref.watch(manageComponentValuesEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return ManageComponentValuesMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        child: ManageComponentValuesBody(),
      );
    }

    if (layout.isTablet) {
      return ManageComponentValuesTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        child: ManageComponentValuesBody(),
      );
    }

    return ManageComponentValuesDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      child: ManageComponentValuesBody(),
    );
  }
}
