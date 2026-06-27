import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/models/position_response.dart';

/// Position repository interface
/// Defines the contract for position data operations
abstract class PositionRepository {
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
    int? tenantId,
  });
  Future<PositionResponse> getPositionsByOrgUnit({
    required String orgUnitId,
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
    int? tenantId,
  });
  Future<Position> createPosition(Map<String, dynamic> positionData, {int? tenantId});
  Future<Position> updatePosition(String id, Map<String, dynamic> positionData, {int? tenantId});
  Future<void> deletePosition(String id, {bool hard = true, int? tenantId});
}
