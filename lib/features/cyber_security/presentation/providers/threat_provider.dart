import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/threat_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/threat_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/threat_repository.dart';

final threatApiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  ),
);

final threatRemoteDataSourceProvider = Provider<ThreatRemoteDataSource>(
  (ref) =>
      DioThreatRemoteDataSource(apiClient: ref.watch(threatApiClientProvider)),
);

final threatRepositoryProvider = Provider<ThreatRepository>(
  (ref) => ThreatRepositoryImpl(
    remoteDataSource: ref.watch(threatRemoteDataSourceProvider),
  ),
);

final liveThreatsProvider = FutureProvider<List<ThreatDto>>(
  (ref) => ref.watch(threatRepositoryProvider).getLiveThreats(),
);
