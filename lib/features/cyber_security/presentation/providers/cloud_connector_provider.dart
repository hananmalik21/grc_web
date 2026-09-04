import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/cloud_connector_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/cloud_connector_repository.dart';

final cloudConnectorApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  );
});

final cloudConnectorRepositoryProvider = Provider<CloudConnectorRepository>((
  ref,
) {
  return CloudConnectorRepositoryImpl(
    remoteDataSource: DioCloudConnectorRemoteDataSource(
      apiClient: ref.watch(cloudConnectorApiClientProvider),
    ),
  );
});

final cloudConnectorsProvider = FutureProvider<List<CloudCoverageConnectorDto>>(
  (ref) {
    return ref.watch(cloudConnectorRepositoryProvider).listConnectors();
  },
);
