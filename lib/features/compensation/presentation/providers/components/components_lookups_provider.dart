import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/usecases/lookups/get_comp_lookup_values_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _getCompLookupValuesUseCaseProvider = Provider<GetCompLookupValuesUseCase>((ref) {
  return GetCompLookupValuesUseCase(repository: ref.watch(compLookupsRepositoryProvider));
});

final componentCategoryLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(componentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(_getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: CompensationLookupType.category.value);
});

final componentCalculationMethodLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(componentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(_getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: CompensationLookupType.calculationMethod.value);
});
