import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/lookups/comp_lookups_remote_data_source.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_graph_count_dto.dart';
import 'package:grc/features/compensation/data/repositories/lookups/comp_lookups_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_type.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/repositories/lookups/comp_lookups_repository.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _compLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final compLookupsRemoteDataSourceProvider = Provider<CompLookupsRemoteDataSource>((ref) {
  return CompLookupsRemoteDataSourceImpl(apiClient: ref.watch(_compLookupsApiClientProvider));
});

final compLookupsRepositoryProvider = Provider<CompLookupsRepository>((ref) {
  return CompLookupsRepositoryImpl(remoteDataSource: ref.watch(compLookupsRemoteDataSourceProvider));
});

final compLookupTypesProvider = FutureProvider<List<CompLookupType>>((ref) async {
  final repo = ref.watch(compLookupsRepositoryProvider);
  return repo.getLookupTypes();
});

/// Lookup values for a given `lookup_type_code`, scoped to the selected tenant.
final compLookupValuesProvider = FutureProvider.family<List<CompLookupValue>, String>((ref, lookupTypeCode) async {
  final tenantId = ref.watch(componentsTabEnterpriseIdProvider);
  if (tenantId == null) return const <CompLookupValue>[];
  final repo = ref.watch(compLookupsRepositoryProvider);
  return repo.getLookupValues(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
});

/// Lookup values for Compensation Plans tab, scoped to its selected enterprise.
final compensationPlansLookupValuesProvider = FutureProvider.family<List<CompLookupValue>, String>((
  ref,
  lookupTypeCode,
) async {
  final tenantId = ref.watch(compensationPlansTabEnterpriseIdProvider);
  if (tenantId == null) return const <CompLookupValue>[];
  final repo = ref.watch(compLookupsRepositoryProvider);
  return repo.getLookupValues(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
});

/// Lookup values for Employee Compensation tab, scoped to its selected enterprise.
final employeeCompensationLookupValuesProvider = FutureProvider.family<List<CompLookupValue>, String>((
  ref,
  lookupTypeCode,
) async {
  final tenantId = ref.watch(compensationEmployeeTabEnterpriseIdProvider);
  if (tenantId == null) return const <CompLookupValue>[];
  final repo = ref.watch(compLookupsRepositoryProvider);
  return repo.getLookupValues(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
});

/// Graph counts for a given lookup type code, scoped to the selected tenant (Components tab).
final compGraphCountsProvider = FutureProvider.family<List<CompLookupGraphCountItemDto>, String>((
  ref,
  lookupTypeCode,
) async {
  final tenantId = ref.watch(componentsTabEnterpriseIdProvider);
  if (tenantId == null) return const <CompLookupGraphCountItemDto>[];
  final repo = ref.watch(compLookupsRepositoryProvider);
  return repo.getGraphCounts(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
});
