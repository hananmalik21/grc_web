import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/payroll/application/lookups/providers/pay_lookups_provider.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_type_code.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<PayLookupValue>> _addElementLookupValues(Ref ref, String typeCode) async {
  final enterpriseId = ref.watch(elementEntriesEnterpriseIdProvider);
  if (enterpriseId == null || enterpriseId <= 0) return const [];

  return ref.watch(
    payLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: typeCode, page: 1, limit: 100)).future,
  );
}

final addElementEntryTypeLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.entryType);
});

final addElementSourceLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.source);
});

final addElementProcessingTypeLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.elementProcessingType);
});

final addElementElementClassificationLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.elementClassificationCode);
});

final addElementContextSegmentLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.contextSegment);
});

final addElementCostAllocationKeyFieldLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.costAllocationKeyField);
});

final addElementCostingTypeLookupValuesProvider = FutureProvider.autoDispose<List<PayLookupValue>>((ref) {
  return _addElementLookupValues(ref, PayLookupTypeCode.costingType);
});

final addElementLookupsPreloadProvider = FutureProvider.autoDispose<void>((ref) async {
  await Future.wait([
    ref.watch(addElementEntryTypeLookupValuesProvider.future),
    ref.watch(addElementSourceLookupValuesProvider.future),
    ref.watch(addElementProcessingTypeLookupValuesProvider.future),
    ref.watch(addElementElementClassificationLookupValuesProvider.future),
    ref.watch(addElementContextSegmentLookupValuesProvider.future),
    ref.watch(addElementCostAllocationKeyFieldLookupValuesProvider.future),
    ref.watch(addElementCostingTypeLookupValuesProvider.future),
  ]);
});
