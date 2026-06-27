import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/hiring/data/datasources/requisitions_remote_data_source.dart';
import 'package:grc/features/hiring/data/repositories/requisitions_repository_impl.dart';
import 'package:grc/features/hiring/data/services/create_requisition_multipart_form_service.dart';
import 'package:grc/features/hiring/data/services/create_requisition_request_conversion_service.dart';
import 'package:grc/features/hiring/domain/repositories/requisitions_repository.dart';
import 'package:grc/features/hiring/domain/usecases/approve_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/close_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/create_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/delete_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_requisition_by_guid_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/get_requisitions_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/hold_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/reject_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/reopen_requisition_usecase.dart';
import 'package:grc/features/hiring/domain/usecases/update_requisition_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:grc/features/hiring/application/requisition/controllers/requisition_action_controllers.dart';
export 'package:grc/features/hiring/application/requisition/providers/requisition_action_state_providers.dart';

final requisitionsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final createRequisitionMultipartFormServiceProvider = Provider<CreateRequisitionMultipartFormService>((ref) {
  return const CreateRequisitionMultipartFormService();
});

final requisitionsRemoteDataSourceProvider = Provider<RequisitionsRemoteDataSource>((ref) {
  return RequisitionsRemoteDataSourceImpl(
    apiClient: ref.watch(requisitionsApiClientProvider),
    multipartFormService: ref.watch(createRequisitionMultipartFormServiceProvider),
  );
});

final requisitionsRepositoryProvider = Provider<RequisitionsRepository>((ref) {
  return RequisitionsRepositoryImpl(remoteDataSource: ref.watch(requisitionsRemoteDataSourceProvider));
});

final getRequisitionsUseCaseProvider = Provider<GetRequisitionsUseCase>((ref) {
  return GetRequisitionsUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final getRequisitionByGuidUseCaseProvider = Provider<GetRequisitionByGuidUseCase>((ref) {
  return GetRequisitionByGuidUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final createRequisitionUseCaseProvider = Provider<CreateRequisitionUseCase>((ref) {
  return CreateRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final updateRequisitionUseCaseProvider = Provider<UpdateRequisitionUseCase>((ref) {
  return UpdateRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final deleteRequisitionUseCaseProvider = Provider<DeleteRequisitionUseCase>((ref) {
  return DeleteRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final rejectRequisitionUseCaseProvider = Provider<RejectRequisitionUseCase>((ref) {
  return RejectRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final approveRequisitionUseCaseProvider = Provider<ApproveRequisitionUseCase>((ref) {
  return ApproveRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final reopenRequisitionUseCaseProvider = Provider<ReopenRequisitionUseCase>((ref) {
  return ReopenRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final closeRequisitionUseCaseProvider = Provider<CloseRequisitionUseCase>((ref) {
  return CloseRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final holdRequisitionUseCaseProvider = Provider<HoldRequisitionUseCase>((ref) {
  return HoldRequisitionUseCase(repository: ref.watch(requisitionsRepositoryProvider));
});

final createRequisitionRequestConversionServiceProvider = Provider<CreateRequisitionRequestConversionService>((ref) {
  return const CreateRequisitionRequestConversionService();
});
