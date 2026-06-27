import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/rec_lookups_provider.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<RecLookupValue>> _createCandidateRecLookupValues(Ref ref, String typeCode) async {
  final enterpriseId = ref.watch(candidatesTabEnterpriseIdProvider);
  if (enterpriseId == null || enterpriseId <= 0) return const [];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: typeCode, page: 1, pageSize: 100)).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
}

final createCandidateCurrencyLookupValuesProvider = FutureProvider.autoDispose<List<RecLookupValue>>((ref) {
  return _createCandidateRecLookupValues(ref, RecLookupTypeCodes.currency);
});

final createCandidateSourceLookupValuesProvider = FutureProvider.autoDispose<List<RecLookupValue>>((ref) {
  return _createCandidateRecLookupValues(ref, RecLookupTypeCodes.source);
});
