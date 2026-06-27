import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/remote/adjustments_remote_datasource.dart';
import 'package:grc/features/compensation/data/repositories/adjustments_repository_impl.dart';
import 'package:grc/features/compensation/domain/repositories/adjustments_repository.dart';
import 'package:grc/features/compensation/domain/usecases/adjustments/get_adjustments_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adjustmentsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final adjustmentsRemoteDataSourceProvider = Provider<AdjustmentsRemoteDataSource>((ref) {
  return AdjustmentsRemoteDataSourceImpl(apiClient: ref.watch(adjustmentsApiClientProvider));
});

final adjustmentsRepositoryProvider = Provider<AdjustmentsRepository>((ref) {
  return AdjustmentsRepositoryImpl(remoteDataSource: ref.watch(adjustmentsRemoteDataSourceProvider));
});

final getAdjustmentsUseCaseProvider = Provider<GetAdjustmentsUseCase>((ref) {
  return GetAdjustmentsUseCase(repository: ref.watch(adjustmentsRepositoryProvider));
});
