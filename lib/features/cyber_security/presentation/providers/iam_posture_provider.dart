import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/cyber_security/data/datasources/iam_posture_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/repositories/iam_posture_repository.dart';

final iamPostureApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    baseUrl: ApiConfig.baseUrl,
    authStorage: ref.watch(authLocalStorageProvider),
  );
});

final iamPostureRemoteDataSourceProvider = Provider<IamPostureRemoteDataSource>(
  (ref) {
    return DioIamPostureRemoteDataSource(
      apiClient: ref.watch(iamPostureApiClientProvider),
    );
  },
);

final iamPostureRepositoryProvider = Provider<IamPostureRepository>((ref) {
  return IamPostureRepositoryImpl(
    remoteDataSource: ref.watch(iamPostureRemoteDataSourceProvider),
  );
});

final iamPostureProvider = FutureProvider<IamPostureData>((ref) {
  return ref.watch(iamPostureRepositoryProvider).getPosture();
});
