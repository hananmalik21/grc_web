import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_employee_components_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void syncBulkAdjustmentsFormFromComponentsPage(WidgetRef ref, BulkEmployeeComponentsPage page) {
  if (page.employees.isEmpty) return;

  final query = ref.read(bulkEmployeeComponentsQueryProvider);
  if (query == null) return;

  final selectionKey = query.employeeGuids.join('\u0001');
  final lastKey = ref.read(bulkEmployeeComponentsSyncKeyProvider);
  final resetExisting = lastKey != selectionKey;
  if (resetExisting) {
    ref.read(bulkEmployeeComponentsSyncKeyProvider.notifier).state = selectionKey;
  }

  ref
      .read(bulkAdjustmentsFormProvider.notifier)
      .syncFromApi(
        page: page,
        employeeLabels: ref.read(bulkSelectedEmployeeLabelsProvider),
        employeeNumericIds: ref.read(bulkSelectedEmployeeNumericIdsProvider),
        resetExisting: resetExisting,
      );
}
