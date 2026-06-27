import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRequisitionContractTypeSelectionDialog extends ConsumerWidget {
  const CreateRequisitionContractTypeSelectionDialog({super.key, this.selectedContractType});

  final EmplLookupValue? selectedContractType;

  static Future<EmplLookupValue?> show({required BuildContext context, EmplLookupValue? selectedContractType}) {
    return DigifySingleSelectDialog.showAdaptive<EmplLookupValue>(
      context: context,
      child: CreateRequisitionContractTypeSelectionDialog(selectedContractType: selectedContractType),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValues = ref.watch(createRequisitionContractTypeLookupValuesProvider);
    final values = asyncValues.valueOrNull ?? const <EmplLookupValue>[];

    return DigifySingleSelectDialog<EmplLookupValue>(
      title: 'Select Contract Type',
      subtitle: 'Choose a contract type from the list',
      headerIcon: Icons.description_rounded,
      items: values,
      selectedId: selectedContractType?.lookupCode,
      idBuilder: (item) => item.lookupCode,
      labelBuilder: (item) => item.meaningEn,
      searchHint: 'Search contract type...',
      emptyMessage: 'No contract types available',
      isLoading: asyncValues.isLoading,
      errorMessage: asyncValues.hasError ? asyncValues.error.toString() : null,
      onRetry: () => ref.invalidate(createRequisitionContractTypeLookupValuesProvider),
    );
  }
}
