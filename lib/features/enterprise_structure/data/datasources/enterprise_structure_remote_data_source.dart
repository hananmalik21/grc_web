import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/save_enterprise_structure_dto.dart';

/// Remote data source for enterprise structure operations
abstract class EnterpriseStructureRemoteDataSource {
  Future<Map<String, dynamic>> saveEnterpriseStructure(
    SaveEnterpriseStructureRequestDto request,
  );
  
  Future<Map<String, dynamic>> updateEnterpriseStructure(
    String structureId,
    SaveEnterpriseStructureRequestDto request,
  );
}

class EnterpriseStructureRemoteDataSourceImpl
    implements EnterpriseStructureRemoteDataSource {
  final ApiClient apiClient;

  EnterpriseStructureRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> saveEnterpriseStructure(
    SaveEnterpriseStructureRequestDto request,
  ) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.hrOrgStructures,
        body: request.toJson(),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to save enterprise structure: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> updateEnterpriseStructure(
    String structureId,
    SaveEnterpriseStructureRequestDto request,
  ) async {
    try {
      final response = await apiClient.put(
        '${ApiEndpoints.hrOrgStructures}/$structureId',
        body: request.toJson(),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update enterprise structure: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

