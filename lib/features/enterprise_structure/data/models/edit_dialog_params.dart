import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';

/// Parameters for edit dialog provider
class EditDialogParams {
  final String structureName;
  final String description;
  final List<HierarchyLevel> initialLevels;
  final int? selectedEnterpriseId;
  final bool isActive;

  const EditDialogParams({
    required this.structureName,
    required this.description,
    required this.initialLevels,
    this.selectedEnterpriseId,
    this.isActive = true,
  });
}

