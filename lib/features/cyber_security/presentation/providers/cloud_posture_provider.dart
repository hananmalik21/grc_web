import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/cloud_posture_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/cloud_posture_dto.dart';
import 'package:grc/features/cyber_security/data/repositories/cloud_posture_repository.dart';

final cloudPostureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  );
});

final cloudPostureRemoteDataSourceProvider =
    Provider<CloudPostureRemoteDataSource>((ref) {
      return DioCloudPostureRemoteDataSource(
        apiClient: ref.watch(cloudPostureApiClientProvider),
      );
    });

final cloudPostureRepositoryProvider = Provider<CloudPostureRepository>((ref) {
  return CloudPostureRepositoryImpl(
    remoteDataSource: ref.watch(cloudPostureRemoteDataSourceProvider),
  );
});

final cloudCoverageProvider = FutureProvider<CloudCoverageDashboardDto>((ref) {
  return ref.watch(cloudPostureRepositoryProvider).getCloudCoverage();
});
