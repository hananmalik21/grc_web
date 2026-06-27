import 'package:grc/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart'
    show getStructureLevelsUseCaseProvider, saveEnterpriseStructureUseCaseProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final structureLevelsForCreateProvider = FutureProvider.autoDispose<List<HierarchyLevel>>((ref) async {
  final useCase = ref.watch(getStructureLevelsUseCaseProvider);
  final list = await useCase();
  return list.map(_structureLevelToHierarchyLevel).toList();
});

HierarchyLevel _structureLevelToHierarchyLevel(StructureLevel s) {
  return HierarchyLevel(
    id: s.id,
    name: s.name,
    icon: s.icon,
    level: s.level,
    isMandatory: s.isMandatory,
    isActive: s.isActive,
    previewIcon: s.previewIcon,
  );
}

final createEnterpriseStructureProvider =
    StateNotifierProvider.autoDispose<EditEnterpriseStructureNotifier, EditEnterpriseStructureState>((ref) {
      return EditEnterpriseStructureNotifier(
        structureName: '',
        description: '',
        initialLevels: const [],
        selectedEnterpriseId: null,
        isActive: true,
      );
    });

final saveEnterpriseStructureDialogProvider =
    StateNotifierProvider.autoDispose<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>((ref) {
      final saveUseCase = ref.watch(saveEnterpriseStructureUseCaseProvider);
      return SaveEnterpriseStructureNotifier(saveUseCase: saveUseCase);
    });

final editEnterpriseStructureDialogProvider = StateNotifierProvider.autoDispose
    .family<EditEnterpriseStructureNotifier, EditEnterpriseStructureState, EditDialogParams>(
      (ref, params) => EditEnterpriseStructureNotifier(
        structureName: params.structureName,
        description: params.description,
        initialLevels: params.initialLevels,
        selectedEnterpriseId: params.selectedEnterpriseId,
        isActive: params.isActive,
      ),
    );
