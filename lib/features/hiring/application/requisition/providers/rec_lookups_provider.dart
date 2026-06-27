import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/hiring/data/datasources/rec_lookups_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/rec_lookups_repository_impl.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/repositories/rec_lookups_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _recLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final recLookupsRemoteDataSourceProvider = Provider<RecLookupsRemoteDataSource>((ref) {
  return RecLookupsRemoteDataSourceImpl(apiClient: ref.watch(_recLookupsApiClientProvider));
});

final recLookupsRepositoryProvider = Provider<RecLookupsRepository>((ref) {
  return RecLookupsRepositoryImpl(remoteDataSource: ref.watch(recLookupsRemoteDataSourceProvider));
});

final recLookupTypesProvider = FutureProvider.family<List<RecLookupType>, ({int enterpriseId, int page, int pageSize})>(
  (ref, params) async {
    if (params.enterpriseId <= 0) return [];
    final repo = ref.watch(recLookupsRepositoryProvider);
    return repo.getLookupTypes(enterpriseId: params.enterpriseId, page: params.page, pageSize: params.pageSize);
  },
);

final recLookupValuesForTypeProvider =
    FutureProvider.family<List<RecLookupValue>, ({int enterpriseId, String typeCode, int page, int pageSize})>((
      ref,
      params,
    ) async {
      if (params.enterpriseId <= 0) return [];
      final repo = ref.watch(recLookupsRepositoryProvider);
      return repo.getLookupValues(
        enterpriseId: params.enterpriseId,
        lookupTypeCode: params.typeCode,
        page: params.page,
        pageSize: params.pageSize,
      );
    });
