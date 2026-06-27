import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/payroll/application/element_entries/providers/add_element_assigned_components_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElementComponentSelectionDialog {
  AddElementComponentSelectionDialog._();

  static Future<EmployeeAssignedComponent?> show(
    BuildContext context, {
    required WidgetRef ref,
    required String employeeGuid,
    String? selectedAssignmentDetailGuid,
  }) {
    return DigifySingleSelectDialog.showAdaptive<EmployeeAssignedComponent>(
      context: context,
      barrierDismissible: false,
      child: _AddElementComponentSelectionDialogContent(
        employeeGuid: employeeGuid,
        selectedAssignmentDetailGuid: selectedAssignmentDetailGuid,
      ),
    );
  }
}

class _AddElementComponentSelectionDialogContent extends ConsumerWidget {
  const _AddElementComponentSelectionDialogContent({required this.employeeGuid, this.selectedAssignmentDetailGuid});

  final String employeeGuid;
  final String? selectedAssignmentDetailGuid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final componentsAsync = ref.watch(addElementAssignedComponentsProvider(employeeGuid));

    return componentsAsync.when(
      data: (components) => _buildDialog(context, ref, loc, components),
      loading: () => _buildDialog(context, ref, loc, const [], isLoading: true),
      error: (error, _) => _buildDialog(context, ref, loc, const [], errorMessage: error.toString()),
    );
  }

  Widget _buildDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations loc,
    List<EmployeeAssignedComponent> components, {
    bool isLoading = false,
    String? errorMessage,
  }) {
    return DigifySingleSelectDialog<EmployeeAssignedComponent>(
      title: loc.payrollAddElementSelectElementTitle,
      subtitle: loc.payrollAddElementSelectElementSubtitle,
      items: components,
      selectedId: selectedAssignmentDetailGuid,
      idBuilder: (component) => component.assignmentDetailGuid,
      labelBuilder: (component) => component.componentName,
      descriptionBuilder: (component) => component.componentCode,
      searchHint: loc.payrollAddElementSelectElementSearchHint,
      emptyMessage: loc.payrollAddElementSelectElementEmpty,
      headerIcon: Icons.payments_outlined,
      isLoading: isLoading,
      errorMessage: errorMessage,
      onRetry: () => ref.invalidate(addElementAssignedComponentsProvider(employeeGuid)),
    );
  }
}
