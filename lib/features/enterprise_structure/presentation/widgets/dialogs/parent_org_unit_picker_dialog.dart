import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final parentOrgUnitsProvider = FutureProvider.autoDispose.family<List<OrgStructureLevel>, ParentOrgUnitsParams>((
  ref,
  params,
) async {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return repository.getParentOrgUnits(params.structureId, params.levelCode);
});

class ParentOrgUnitsParams {
  final String structureId;
  final String levelCode;

  const ParentOrgUnitsParams({required this.structureId, required this.levelCode});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentOrgUnitsParams &&
          runtimeType == other.runtimeType &&
          structureId == other.structureId &&
          levelCode == other.levelCode;

  @override
  int get hashCode => structureId.hashCode ^ levelCode.hashCode;
}

class ParentOrgUnitPickerDialog {
  ParentOrgUnitPickerDialog._();

  static Future<OrgStructureLevel?> show(
    BuildContext context, {
    required String structureId,
    required String levelCode,
    String? selectedParentId,
  }) {
    return DigifySingleSelectDialog.showAdaptive<OrgStructureLevel>(
      context: context,
      barrierDismissible: false,
      child: _ParentOrgUnitPickerContent(
        structureId: structureId,
        levelCode: levelCode,
        selectedParentId: selectedParentId,
      ),
    );
  }
}

class _ParentOrgUnitPickerContent extends ConsumerWidget {
  const _ParentOrgUnitPickerContent({required this.structureId, required this.levelCode, this.selectedParentId});

  final String structureId;
  final String levelCode;
  final String? selectedParentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUnits = ref.watch(
      parentOrgUnitsProvider(ParentOrgUnitsParams(structureId: structureId, levelCode: levelCode)),
    );

    return asyncUnits.when(
      data: (units) => DigifySingleSelectDialog<OrgStructureLevel>(
        title: 'Select Parent',
        subtitle: 'Choose the parent org unit',
        items: units,
        selectedId: selectedParentId,
        idBuilder: (u) => u.orgUnitId,
        labelBuilder: (u) => u.displayName,
        descriptionBuilder: (u) => u.levelCode,
        searchHint: 'Search org units...',
        emptyMessage: 'No parent units found',
        headerIcon: Icons.account_tree_rounded,
      ),
      loading: () => DigifySingleSelectDialog<OrgStructureLevel>(
        title: 'Select Parent',
        subtitle: 'Choose the parent org unit',
        items: const [],
        selectedId: selectedParentId,
        idBuilder: (u) => u.orgUnitId,
        labelBuilder: (u) => u.displayName,
        isLoading: true,
        headerIcon: Icons.account_tree_rounded,
      ),
      error: (err, _) => DigifySingleSelectDialog<OrgStructureLevel>(
        title: 'Select Parent',
        subtitle: 'Choose the parent org unit',
        items: const [],
        selectedId: selectedParentId,
        idBuilder: (u) => u.orgUnitId,
        labelBuilder: (u) => u.displayName,
        errorMessage: err.toString(),
        onRetry: () => ref.invalidate(
          parentOrgUnitsProvider(ParentOrgUnitsParams(structureId: structureId, levelCode: levelCode)),
        ),
        headerIcon: Icons.account_tree_rounded,
      ),
    );
  }
}
