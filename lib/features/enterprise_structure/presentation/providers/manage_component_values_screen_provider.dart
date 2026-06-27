import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/active_levels_provider.dart'
    show manageComponentValuesActiveLevelsProvider;
import 'package:grc/features/enterprise_structure/presentation/providers/active_structure_stats_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_tree_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/add_org_unit_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/add_org_unit_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageComponentValuesScreenState {
  final OrganizationLevel? selectedLevel;
  final String selectedLevelCode;
  final String orgUnitsSearchQuery;
  final bool isProcessing;
  final bool isTreeView;
  final String? deletingOrgUnitId;

  const ManageComponentValuesScreenState({
    this.selectedLevel,
    this.selectedLevelCode = '',
    this.orgUnitsSearchQuery = '',
    this.isProcessing = false,
    this.isTreeView = true,
    this.deletingOrgUnitId,
  });

  ManageComponentValuesScreenState copyWith({
    OrganizationLevel? Function()? selectedLevel,
    String? selectedLevelCode,
    String? orgUnitsSearchQuery,
    bool? isProcessing,
    bool? isTreeView,
    String? deletingOrgUnitId,
    bool clearDeletingOrgUnitId = false,
  }) {
    return ManageComponentValuesScreenState(
      selectedLevel: selectedLevel != null ? selectedLevel() : this.selectedLevel,
      selectedLevelCode: selectedLevelCode ?? this.selectedLevelCode,
      orgUnitsSearchQuery: orgUnitsSearchQuery ?? this.orgUnitsSearchQuery,
      isProcessing: isProcessing ?? this.isProcessing,
      isTreeView: isTreeView ?? this.isTreeView,
      deletingOrgUnitId: clearDeletingOrgUnitId ? null : (deletingOrgUnitId ?? this.deletingOrgUnitId),
    );
  }
}

class ManageComponentValuesScreenNotifier extends StateNotifier<ManageComponentValuesScreenState> {
  final Ref _ref;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  ManageComponentValuesScreenNotifier(this._ref) : super(const ManageComponentValuesScreenState());

  void selectTreeView() {
    state = state.copyWith(selectedLevel: () => null, selectedLevelCode: '', orgUnitsSearchQuery: '', isTreeView: true);
    _ref.read(orgUnitsTreeProvider.notifier).refresh();
  }

  void selectLevel(ActiveStructureLevel level) {
    final levelCode = level.levelCode.toUpperCase();
    state = state.copyWith(
      selectedLevel: () => OrganizationLevel.fromCode(level.levelCode),
      selectedLevelCode: levelCode,
      orgUnitsSearchQuery: '',
      isTreeView: false,
    );
  }

  void handleSearch(String levelCode, String query) {
    state = state.copyWith(orgUnitsSearchQuery: query);

    _debouncer.run(() {
      _ref.read(orgUnitsProvider(levelCode).notifier).search(query);
    });
  }

  Future<void> deleteOrgUnit(
    BuildContext context,
    OrganizationLevel level,
    OrgStructureLevel unit, {
    String? levelCode,
  }) async {
    final code = levelCode ?? level.code;
    if (code.isEmpty) return;

    state = state.copyWith(isProcessing: true, deletingOrgUnitId: unit.orgUnitId);
    try {
      final activeLevels = _ref.read(manageComponentValuesActiveLevelsProvider);
      if (activeLevels.levels.isEmpty) {
        ToastService.error(context, 'No active levels available');
        state = state.copyWith(isProcessing: false, clearDeletingOrgUnitId: true);
        return;
      }
      final activeLevel = activeLevels.levels.firstWhere(
        (l) => l.levelCode.toUpperCase() == code,
        orElse: () => activeLevels.levels.first,
      );

      final deleteUseCase = _ref.read(deleteOrgUnitUseCaseProvider);
      await deleteUseCase.call(activeLevel.structureId, unit.orgUnitId, hard: true);

      if (context.mounted) {
        ToastService.success(context, '${unit.orgUnitNameEn} deleted successfully');
        _ref.read(orgUnitsProvider(code).notifier).removeUnitLocal(unit.orgUnitId);
        _ref.read(activeStructureStatsNotifierProvider.notifier).refresh();
        _ref.read(orgUnitsTreeProvider.notifier).refresh();
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete: ${e.toString()}');
      }
    } finally {
      state = state.copyWith(isProcessing: false, clearDeletingOrgUnitId: true);
    }
  }

  void handleAddOrgUnit(BuildContext context, OrganizationLevel level, {String? levelCode, bool isMobile = false}) {
    final code = levelCode ?? level.code;
    if (code.isEmpty) return;

    final activeLevels = _ref.read(manageComponentValuesActiveLevelsProvider);
    if (activeLevels.levels.isEmpty) {
      ToastService.error(context, 'No active levels available');
      return;
    }
    final activeLevel = activeLevels.levels.firstWhere(
      (l) => l.levelCode.toUpperCase() == code,
      orElse: () => activeLevels.levels.first,
    );

    if (isMobile) {
      AddOrgUnitMobileSheet.show(context, structureId: activeLevel.structureId, levelCode: code);
    } else {
      AddOrgUnitDialog.show(context, structureId: activeLevel.structureId, levelCode: code);
    }
  }

  void handleEditOrgUnit(
    BuildContext context,
    OrganizationLevel level,
    OrgStructureLevel unit, {
    String? levelCode,
    bool isMobile = false,
  }) {
    final code = levelCode ?? level.code;
    if (code.isEmpty) return;

    final activeLevels = _ref.read(manageComponentValuesActiveLevelsProvider);
    if (activeLevels.levels.isEmpty) {
      ToastService.error(context, 'No active levels available');
      return;
    }
    final activeLevel = activeLevels.levels.firstWhere(
      (l) => l.levelCode.toUpperCase() == code,
      orElse: () => activeLevels.levels.first,
    );

    if (isMobile) {
      AddOrgUnitMobileSheet.show(context, structureId: activeLevel.structureId, levelCode: code, initialValue: unit);
    } else {
      AddOrgUnitDialog.show(context, structureId: activeLevel.structureId, levelCode: code, initialValue: unit);
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

final manageComponentValuesScreenProvider =
    StateNotifierProvider.autoDispose<ManageComponentValuesScreenNotifier, ManageComponentValuesScreenState>((ref) {
      return ManageComponentValuesScreenNotifier(ref);
    });
