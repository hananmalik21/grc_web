import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Specialized widget for Company Level selection
class CompanySelectionField extends ConsumerWidget {
  final OrgStructureLevel level;
  final StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider;
  final Function(String levelCode, String? unitId) onSelectionChanged;
  final bool showPaginationControls;

  const CompanySelectionField({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.onSelectionChanged,
    this.showPaginationControls = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrgUnitSelectionField(
      level: level,
      selectionProvider: selectionProvider,
      isEnabled: true,
      onSelectionChanged: onSelectionChanged,
      showPaginationControls: showPaginationControls,
    );
  }
}

/// Specialized widget for Business Unit Level selection
class BusinessUnitSelectionField extends ConsumerWidget {
  final OrgStructureLevel level;
  final StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider;
  final bool isEnabled;
  final Function(String levelCode, String? unitId) onSelectionChanged;
  final bool showPaginationControls;

  const BusinessUnitSelectionField({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.isEnabled,
    required this.onSelectionChanged,
    this.showPaginationControls = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OrgUnitSelectionField(
      level: level,
      selectionProvider: selectionProvider,
      isEnabled: isEnabled,
      onSelectionChanged: onSelectionChanged,
      showPaginationControls: showPaginationControls,
    );
  }
}
