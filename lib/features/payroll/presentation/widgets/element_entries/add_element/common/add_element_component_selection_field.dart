import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_component_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElementComponentSelectionField extends ConsumerWidget {
  const AddElementComponentSelectionField({
    required this.label,
    required this.employeeGuid,
    required this.selectedComponent,
    required this.onChanged,
    this.isRequired = false,
    super.key,
  });

  final String label;
  final String? employeeGuid;
  final EmployeeAssignedComponent? selectedComponent;
  final ValueChanged<EmployeeAssignedComponent?> onChanged;
  final bool isRequired;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final hasEmployee = employeeGuid != null && employeeGuid!.trim().isNotEmpty;

    return DigifySelectionFieldWithLabel(
      label: label,
      hint: loc.payrollAddElementSelectElementTitle,
      value: selectedComponent?.componentName,
      isRequired: isRequired,
      isEnabled: hasEmployee,
      onTap: hasEmployee
          ? () async {
              final selected = await AddElementComponentSelectionDialog.show(
                context,
                ref: ref,
                employeeGuid: employeeGuid!,
                selectedAssignmentDetailGuid: selectedComponent?.assignmentDetailGuid,
              );

              if (selected != null) {
                onChanged(selected);
              }
            }
          : () => ToastService.warning(context, loc.payrollAddElementSelectEmployeeForElement),
    );
  }
}
