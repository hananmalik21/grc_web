import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/bulk_adjustments/bulk_adjustments_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/bulk_adjustments/bulk_adjustments_repository_impl.dart';
import 'package:grc/features/compensation/domain/repositories/bulk_adjustments/bulk_adjustments_repository.dart';
import 'package:grc/features/compensation/domain/usecases/bulk_adjustments/create_bulk_adjustment_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/bulk_adjustments/get_bulk_eligible_plans_usecase.dart';
import 'package:grc/features/compensation/domain/usecases/bulk_adjustments/get_bulk_employee_components_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bulkAdjustmentsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final bulkAdjustmentsRemoteDataSourceProvider = Provider<BulkAdjustmentsRemoteDataSource>((ref) {
  return BulkAdjustmentsRemoteDataSourceImpl(apiClient: ref.watch(bulkAdjustmentsApiClientProvider));
});

final bulkAdjustmentsRepositoryProvider = Provider<BulkAdjustmentsRepository>((ref) {
  return BulkAdjustmentsRepositoryImpl(remoteDataSource: ref.watch(bulkAdjustmentsRemoteDataSourceProvider));
});

final getBulkEmployeeComponentsUseCaseProvider = Provider<GetBulkEmployeeComponentsUseCase>((ref) {
  return GetBulkEmployeeComponentsUseCase(repository: ref.watch(bulkAdjustmentsRepositoryProvider));
});

final createBulkAdjustmentUseCaseProvider = Provider<CreateBulkAdjustmentUseCase>((ref) {
  return CreateBulkAdjustmentUseCase(repository: ref.watch(bulkAdjustmentsRepositoryProvider));
});

final getBulkEligiblePlansUseCaseProvider = Provider<GetBulkEligiblePlansUseCase>((ref) {
  return GetBulkEligiblePlansUseCase(repository: ref.watch(bulkAdjustmentsRepositoryProvider));
});
