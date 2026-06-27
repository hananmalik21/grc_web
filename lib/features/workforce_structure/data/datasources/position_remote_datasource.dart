import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/workforce_structure/data/models/position_model.dart';
import 'package:grc/features/workforce_structure/data/models/position_response_model.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/models/position_response.dart';

/// Position remote data source interface
abstract class PositionRemoteDataSource {
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

/// Position remote data source implementation
class PositionRemoteDataSourceImpl implements PositionRemoteDataSource {
  final ApiClient apiClient;

  const PositionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PositionResponse> getPositions({
    int page = 1,
    int pageSize = 10,
    String? search,
    PositionStatus? status,
    int? tenantId,
  }) async {
    final queryParameters = {'page': page.toString(), 'page_size': pageSize.toString()};

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    if (status != null) {
      queryParameters['status'] = status.name;
    }

    if (tenantId != null) {
      queryParameters['tenant_id'] = tenantId.toString();
    }

    final response = await apiClient.get(ApiEndpoints.positions, queryParameters: queryParameters);

    return PositionResponseModel.fromJson(response).toEntity();
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
    final queryParameters = {'org_unit_id': orgUnitId, 'page': page.toString(), 'page_size': pageSize.toString()};

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    if (status != null) {
      queryParameters['status'] = status.name;
    }

    if (tenantId != null) {
      queryParameters['tenant_id'] = tenantId.toString();
    }

    final response = await apiClient.get(ApiEndpoints.positionsByOrgUnit, queryParameters: queryParameters);

    return PositionResponseModel.fromJson(response).toEntity();
  }

  @override
  Future<Position> createPosition(Map<String, dynamic> positionData, {int? tenantId}) async {
    if (tenantId != null) positionData['tenant_id'] = tenantId;
    final response = await apiClient.post(ApiEndpoints.positions, body: positionData);

    final data = response['data'] as Map<String, dynamic>;
    return PositionModel.fromJson(data).toEntity();
  }

  @override
  Future<Position> updatePosition(String id, Map<String, dynamic> positionData, {int? tenantId}) async {
    if (tenantId != null) positionData['tenant_id'] = tenantId;
    final response = await apiClient.put('${ApiEndpoints.positions}/$id', body: positionData);

    final data = response['data'] as Map<String, dynamic>;
    return PositionModel.fromJson(data).toEntity();
  }

  @override
  Future<void> deletePosition(String id, {bool hard = true, int? tenantId}) async {
    final queryParameters = <String, String>{'hard': hard.toString()};
    if (tenantId != null) {
      queryParameters['tenant_id'] = tenantId.toString();
    }
    await apiClient.delete('${ApiEndpoints.positions}/$id', queryParameters: queryParameters);
  }
}
