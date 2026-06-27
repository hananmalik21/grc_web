import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/employee_management/data/datasources/empl_lookup_remote_data_source.dart';
import 'package:grc/features/employee_management/data/repositories/empl_lookup_repository_impl.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_type.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/domain/repositories/empl_lookup_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const List<String> demographicsStepTypeCodes = ['GENDER', 'NATIONALITY', 'MARITAL_STATUS', 'RELIGION'];

final _emplLookupApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final emplLookupRemoteDataSourceProvider = Provider<EmplLookupRemoteDataSource>((ref) {
  return EmplLookupRemoteDataSourceImpl(apiClient: ref.watch(_emplLookupApiClientProvider));
});

final emplLookupRepositoryProvider = Provider<EmplLookupRepository>((ref) {
  return EmplLookupRepositoryImpl(remoteDataSource: ref.watch(emplLookupRemoteDataSourceProvider));
});

final emplLookupTypesProvider = FutureProvider.family<List<EmplLookupType>, int>((ref, enterpriseId) async {
  if (enterpriseId <= 0) return [];
  final repo = ref.watch(emplLookupRepositoryProvider);
  return repo.getLookupTypes(enterpriseId);
});

final emplLookupTypesForDemographicsStepProvider = FutureProvider.family<List<EmplLookupType>, int>((
  ref,
  enterpriseId,
) async {
  final all = await ref.watch(emplLookupTypesProvider(enterpriseId).future);
  final allowed = demographicsStepTypeCodes.map((c) => c.toUpperCase()).toSet();
  return all.where((t) => allowed.contains(t.typeCode.toUpperCase())).toList();
});

final emplLookupValuesForTypeProvider =
    FutureProvider.family<List<EmplLookupValue>, ({int enterpriseId, String typeCode})>((ref, params) async {
      if (params.enterpriseId <= 0) return [];
      final repo = ref.watch(emplLookupRepositoryProvider);
      return repo.getLookupValues(params.enterpriseId, params.typeCode);
    });
