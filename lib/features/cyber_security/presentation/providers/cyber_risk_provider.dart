import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/people_risk_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cyber_paged_dto.dart';
import 'package:grc/features/cyber_security/data/models/cyber_risk_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/people_risk_repository.dart';

final cyberRiskApiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  ),
);

final peopleRiskRepositoryProvider = Provider<PeopleRiskRepository>(
  (ref) => PeopleRiskRepositoryImpl(
    remoteDataSource: DioPeopleRiskRemoteDataSource(
      apiClient: ref.watch(cyberRiskApiClientProvider),
    ),
  ),
);

final peopleRiskRegisterProvider = FutureProvider<CyberPagedDto<PeopleRiskDto>>(
  (ref) => ref.watch(peopleRiskRepositoryProvider).getRiskRegister(),
);

final peopleHeatmapProvider = FutureProvider<List<PeopleHeatmapDepartmentDto>>(
  (ref) => ref.watch(peopleRiskRepositoryProvider).getHeatmap(),
);
