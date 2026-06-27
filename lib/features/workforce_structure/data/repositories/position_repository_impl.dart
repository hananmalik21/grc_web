import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/workforce_structure/data/datasources/position_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/models/position_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/position_repository.dart';

/// Position repository implementation
/// Implements the repository interface and delegates to data sources
class PositionRepositoryImpl implements PositionRepository {
  final PositionRemoteDataSource remoteDataSource;

  const PositionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
    int? tenantId,
  }) async {
    return await remoteDataSource.getPositions(
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      tenantId: tenantId,
    );
  }

  @override
  Future<PositionResponse> getPositionsByOrgUnit({
    required String orgUnitId,
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
    int? tenantId,
  }) async {
    return remoteDataSource.getPositionsByOrgUnit(
      orgUnitId: orgUnitId,
      page: page,
      pageSize: pageSize,
      search: search,
      status: status,
      tenantId: tenantId,
    );
  }

  @override
  Future<Position> createPosition(Map<String, dynamic> positionData, {int? tenantId}) async {
    return await remoteDataSource.createPosition(positionData, tenantId: tenantId);
  }

  @override
  Future<Position> updatePosition(String id, Map<String, dynamic> positionData, {int? tenantId}) async {
    return await remoteDataSource.updatePosition(id, positionData, tenantId: tenantId);
  }

  @override
  Future<void> deletePosition(String id, {bool hard = true, int? tenantId}) async {
    await remoteDataSource.deletePosition(id, hard: hard, tenantId: tenantId);
  }
}
