import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _frequencyLookupCode = 'FREQUENCY';

final compensationPlanFrequencyLookupProvider = FutureProvider<List<CompLookupValue>>((ref) {
  return ref.watch(compensationPlansLookupValuesProvider(_frequencyLookupCode).future);
});

final componentFrequencyProvider = StateProvider.autoDispose.family<CompLookupValue?, int>((ref, componentId) => null);

final componentFrequencyValidationTriggeredProvider = StateProvider.autoDispose<bool>((ref) => false);
