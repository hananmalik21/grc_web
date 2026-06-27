import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/business_unit_dto.dart';

/// Remote data source for business unit operations
abstract class BusinessUnitRemoteDataSource {
  Future<PaginatedBusinessUnitsDto> getBusinessUnits({
    String? search,
    int page = 1,
    int pageSize = 10,
  });
  Future<BusinessUnitDto> createBusinessUnit(Map<String, dynamic> businessUnitData);
  Future<BusinessUnitDto> updateBusinessUnit(int businessUnitId, Map<String, dynamic> businessUnitData);
  Future<void> deleteBusinessUnit(int businessUnitId, {bool hard = true});
}

class BusinessUnitRemoteDataSourceImpl implements BusinessUnitRemoteDataSource {
  final ApiClient apiClient;

  BusinessUnitRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedBusinessUnitsDto> getBusinessUnits({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      // Build query parameters
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      final response = await apiClient.get(
        ApiEndpoints.businessUnits,
        queryParameters: queryParameters,
      );

      return PaginatedBusinessUnitsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch business units: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<BusinessUnitDto> createBusinessUnit(Map<String, dynamic> businessUnitData) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.businessUnits,
        body: businessUnitData,
      );

      // Handle different response formats
      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return BusinessUnitDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create business unit: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<BusinessUnitDto> updateBusinessUnit(int businessUnitId, Map<String, dynamic> businessUnitData) async {
    try {
      final response = await apiClient.put(
        '${ApiEndpoints.businessUnits}/$businessUnitId',
        body: businessUnitData,
      );

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return BusinessUnitDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update business unit: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteBusinessUnit(int businessUnitId, {bool hard = true}) async {
    try {
      await apiClient.delete(
        '${ApiEndpoints.businessUnits}/$businessUnitId',
        queryParameters: {'hard': hard.toString()},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete business unit: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

