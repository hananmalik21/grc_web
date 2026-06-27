import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/workforce_structure/data/datasources/position_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/position_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/repositories/position_repository.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_position_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Position remote data source provider
final positionRemoteDataSourceProvider = Provider<PositionRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PositionRemoteDataSourceImpl(apiClient: apiClient);
});

/// Position repository provider
final positionRepositoryProvider = Provider<PositionRepository>((ref) {
  final remoteDataSource = ref.watch(positionRemoteDataSourceProvider);
  return PositionRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Get positions use case provider
final getPositionsUseCaseProvider = Provider<GetPositionsUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return GetPositionsUseCase(repository: repository);
});

/// Create position use case provider
final createPositionUseCaseProvider = Provider<CreatePositionUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return CreatePositionUseCase(repository: repository);
});

/// Update position use case provider
final updatePositionUseCaseProvider = Provider<UpdatePositionUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return UpdatePositionUseCase(repository: repository);
});

/// Delete position use case provider
final deletePositionUseCaseProvider = Provider<DeletePositionUseCase>((ref) {
  final repository = ref.watch(positionRepositoryProvider);
  return DeletePositionUseCase(repository: repository);
});

/// Position notifier provider
final positionNotifierProvider = StateNotifierProvider<PositionNotifier, PaginationState<Position>>((ref) {
  final getPositionsUseCase = ref.watch(getPositionsUseCaseProvider);
  final createPositionUseCase = ref.watch(createPositionUseCaseProvider);
  final updatePositionUseCase = ref.watch(updatePositionUseCaseProvider);
  final tenantId = ref.watch(positionsEnterpriseIdProvider);
  final deletePositionUseCase = ref.watch(deletePositionUseCaseProvider);
  final notifier = PositionNotifier(
    getPositionsUseCase,
    createPositionUseCase,
    updatePositionUseCase,
    deletePositionUseCase,
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});
