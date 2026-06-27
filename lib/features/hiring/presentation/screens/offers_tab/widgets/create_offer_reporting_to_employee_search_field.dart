import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/reporting_to_employee_search_field.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_tab_enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateOfferReportingToEmployeeSearchField extends ConsumerWidget {
  const CreateOfferReportingToEmployeeSearchField({
    super.key,
    required this.label,
    required this.onEmployeeSelected,
    this.isRequired = false,
    this.selectedEmployee,
    this.hintText,
  });

  final String label;
  final bool isRequired;
  final EmployeeListItem? selectedEmployee;
  final ValueChanged<EmployeeListItem?> onEmployeeSelected;
  final String? hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(offersTabEnterpriseIdProvider);

    return ProviderScope(
      overrides: [manageEmployeesEnterpriseIdProvider.overrideWith((ref) => enterpriseId)],
      child: ReportingToEmployeeSearchField(
        label: label,
        isRequired: isRequired,
        selectedEmployee: selectedEmployee,
        onEmployeeSelected: onEmployeeSelected,
        hintText: hintText,
      ),
    );
  }
}
