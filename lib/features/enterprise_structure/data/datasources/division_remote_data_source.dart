import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/division_dto.dart';

abstract class DivisionRemoteDataSource {
  Future<List<DivisionDto>> getDivisions({int? enterpriseId, String? search, int? page, int? pageSize});
  Future<DivisionDto> createDivision(Map<String, dynamic> divisionData);
  Future<DivisionDto> updateDivision(int divisionId, Map<String, dynamic> divisionData);
  Future<void> deleteDivision(int divisionId, {bool hard = true});
}

class DivisionRemoteDataSourceImpl implements DivisionRemoteDataSource {
  final ApiClient apiClient;

  DivisionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<DivisionDto>> getDivisions({int? enterpriseId, String? search, int? page, int? pageSize}) async {
    try {
      final queryParameters = <String, String>{};
      if (enterpriseId != null) {
        queryParameters['enterprise_id'] = enterpriseId.toString();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }
      if (page != null) {
        queryParameters['page'] = page.toString();
      }
      if (pageSize != null) {
        queryParameters['page_size'] = pageSize.toString();
      }

      final response = await apiClient.get(
        ApiEndpoints.divisions,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('divisions') && response['divisions'] is List) {
        data = response['divisions'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data.whereType<Map<String, dynamic>>().map((json) => DivisionDto.fromJson(json)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch divisions: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<DivisionDto> createDivision(Map<String, dynamic> divisionData) async {
    try {
      final response = await apiClient.post(ApiEndpoints.divisions, body: divisionData);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return DivisionDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create division: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<DivisionDto> updateDivision(int divisionId, Map<String, dynamic> divisionData) async {
    try {
      final response = await apiClient.put('${ApiEndpoints.divisions}/$divisionId', body: divisionData);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return DivisionDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update division: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteDivision(int divisionId, {bool hard = true}) async {
    try {
      await apiClient.delete('${ApiEndpoints.divisions}/$divisionId', queryParameters: {'hard': hard.toString()});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete division: ${e.toString()}', originalError: e);
    }
  }
}
