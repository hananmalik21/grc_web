import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/workforce_structure/data/datasources/ent_lookup_remote_data_source.dart';
import 'package:grc/features/workforce_structure/data/repositories/ent_lookup_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/repositories/ent_lookup_repository.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _entLookupApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final entLookupRemoteDataSourceProvider = Provider<EntLookupRemoteDataSource>((ref) {
  return EntLookupRemoteDataSourceImpl(apiClient: ref.watch(_entLookupApiClientProvider));
});

final entLookupRepositoryProvider = Provider<EntLookupRepository>((ref) {
  return EntLookupRepositoryImpl(remoteDataSource: ref.read(entLookupRemoteDataSourceProvider));
});

final entLookupValuesForTypeProvider = FutureProvider.autoDispose
    .family<List<EmplLookupValue>, ({int enterpriseId, String typeCode})>((ref, params) async {
      if (params.enterpriseId <= 0) return [];
      final repo = ref.watch(entLookupRepositoryProvider);
      return repo.getLookupValues(params.enterpriseId, params.typeCode);
    });

final gradeCategoryLookupValuesProvider = FutureProvider.autoDispose<List<EmplLookupValue>>((ref) async {
  final enterpriseId = ref.watch(gradeStructureEnterpriseIdProvider);
  if (enterpriseId == null) return [];
  final repo = ref.watch(entLookupRepositoryProvider);
  return repo.getLookupValues(enterpriseId, 'GRADE_CATEGORY');
});

final gradeNumberLookupValuesProvider = FutureProvider.autoDispose<List<EmplLookupValue>>((ref) async {
  final enterpriseId = ref.watch(gradeStructureEnterpriseIdProvider);
  if (enterpriseId == null) return [];
  final repo = ref.watch(entLookupRepositoryProvider);
  return repo.getLookupValues(enterpriseId, 'GRADE_NUMBER');
});

final employmentTypeLookupValuesProvider = FutureProvider.autoDispose<List<EmplLookupValue>>((ref) async {
  final enterpriseId = ref.watch(positionsEnterpriseIdProvider);
  if (enterpriseId == null) return [];
  final repo = ref.watch(entLookupRepositoryProvider);
  return repo.getLookupValues(enterpriseId, 'EMPLOYEMENT_TYPE');
});
