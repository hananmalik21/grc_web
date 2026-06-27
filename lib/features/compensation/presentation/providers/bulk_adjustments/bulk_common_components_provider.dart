import 'package:grc/features/compensation/presentation/models/bulk_adjustments/bulk_common_component.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_employee_components_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bulkCommonComponentsProvider = Provider.autoDispose<List<BulkCommonComponent>>((ref) {
  final page = ref.watch(bulkEmployeeComponentsProvider).valueOrNull;
  if (page == null) return const [];
  return findCommonBulkComponents(page.employees);
});
