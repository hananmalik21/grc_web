import 'package:grc/features/hiring/application/interviews/providers/create_new_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/rec_lookups_provider.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<List<RecLookupValue>> _createNewInterviewRecLookupValues(Ref ref, String typeCode) async {
  final enterpriseId = ref.watch(createNewInterviewEnterpriseIdProvider);
  if (enterpriseId == null || enterpriseId <= 0) return const [];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: typeCode, page: 1, pageSize: 100)).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
}

final createNewInterviewTypeLookupValuesProvider = FutureProvider.autoDispose<List<RecLookupValue>>(
  dependencies: [createNewInterviewEnterpriseIdProvider],
  (ref) {
    return _createNewInterviewRecLookupValues(ref, RecLookupTypeCodes.interviewType);
  },
);
