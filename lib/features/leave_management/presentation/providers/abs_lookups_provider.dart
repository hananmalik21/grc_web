import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/leave_management/data/datasources/abs_lookups_remote_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/abs_lookups_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/domain/repositories/abs_lookups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _absLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _absLookupsRemoteDataSourceProvider = Provider<AbsLookupsRemoteDataSource>((ref) {
  final apiClient = ref.watch(_absLookupsApiClientProvider);
  return AbsLookupsRemoteDataSourceImpl(apiClient: apiClient);
});

final absLookupsRepositoryProvider = Provider<AbsLookupsRepository>((ref) {
  final dataSource = ref.watch(_absLookupsRemoteDataSourceProvider);
  return AbsLookupsRepositoryImpl(remoteDataSource: dataSource);
});

final absLookupsForEnterpriseProvider = FutureProvider.family<List<AbsLookup>, int>((ref, enterpriseId) async {
  final repository = ref.watch(absLookupsRepositoryProvider);
  return repository.getLookups(tenantId: enterpriseId);
});

final absLookupValuesForEnterpriseProvider = FutureProvider.family<Map<String, List<AbsLookupValue>>, int>((
  ref,
  enterpriseId,
) async {
  final repository = ref.watch(absLookupsRepositoryProvider);
  final lookups = await ref.watch(absLookupsForEnterpriseProvider(enterpriseId).future);
  final map = <String, List<AbsLookupValue>>{};
  for (final lookup in lookups) {
    final values = await repository.getLookupValues(lookupId: lookup.lookupId, tenantId: enterpriseId);
    final active = values.where((v) => v.isActive).toList()..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    map[lookup.lookupCode] = active;
  }
  return map;
});

final absLookupValuesForEnterpriseAndCodeProvider =
    Provider.family<List<AbsLookupValue>, ({int enterpriseId, AbsLookupCode code})>((ref, params) {
      final async = ref.watch(absLookupValuesForEnterpriseProvider(params.enterpriseId));
      return async.when(
        data: (map) => map[params.code.code] ?? [],
        loading: () => <AbsLookupValue>[],
        error: (_, _) => <AbsLookupValue>[],
      );
    });
