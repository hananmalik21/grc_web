import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/usecases/lookups/get_comp_lookup_values_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getCompLookupValuesUseCaseProvider = Provider<GetCompLookupValuesUseCase>((ref) {
  return GetCompLookupValuesUseCase(repository: ref.watch(compLookupsRepositoryProvider));
});

final adjustmentTypeLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(adjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'ADJUSTMENT_TYPE');
});

final budgetCodeLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(adjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'BUDGET_CODE');
});

final reasonCodeLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(adjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'REASON_CODE');
});

final performanceRatingLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(adjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'PERFORMANCE_RATING');
});

final adjustmentMethodLookupProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(adjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'ADJUSTMENT_METHOD');
});

final bulkAdjustmentMethodLookupProvider = FutureProvider.autoDispose<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(bulkAdjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'ADJUSTMENT_METHOD');
});

final bulkReasonCodeLookupProvider = FutureProvider.autoDispose<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(bulkAdjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'REASON_CODE');
});

final bulkBudgetCodeLookupProvider = FutureProvider.autoDispose<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(bulkAdjustmentsTabEnterpriseIdProvider);
  if (tenantId == null) return const [];

  final useCase = ref.watch(getCompLookupValuesUseCaseProvider);
  return useCase(tenantId: tenantId, lookupTypeCode: 'BUDGET_CODE');
});
