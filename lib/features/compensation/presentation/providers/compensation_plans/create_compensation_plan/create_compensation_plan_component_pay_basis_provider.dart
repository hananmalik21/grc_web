import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _payBasisLookupCode = 'PAY_BASIS';

final compensationPlanPayBasisLookupProvider = FutureProvider<List<CompLookupValue>>((ref) {
  return ref.watch(compensationPlansLookupValuesProvider(_payBasisLookupCode).future);
});
