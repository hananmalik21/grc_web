import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_full_details_dto.dart';
import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_page_dto.dart';
import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_details_dto.dart';

import '../../dto/salary_structure_management/create_salary_structure_request_dto.dart';

abstract class SalaryStructureRemoteDataSource {
  Future<void> createSalaryStructure(CreateSalaryStructureRequestDto request);
  Future<void> updateSalaryStructure({required String structureGuid, required CreateSalaryStructureRequestDto request});
  Future<void> deleteSalaryStructure({required String structureGuid});
  Future<SalaryStructurePageDto> getSalaryStructures({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? status,
  });
  Future<SalaryStructureDetailsDto> getSalaryStructureDetails({
    required int enterpriseId,
    required String structureGuid,
  });
  Future<SalaryStructureFullDetailsDto> getSalaryStructureFullDetails({
    required int enterpriseId,
    required String structureGuid,
  });
}

class SalaryStructureRemoteDataSourceImpl implements SalaryStructureRemoteDataSource {
  final ApiClient apiClient;

  SalaryStructureRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders() {
    return {'x-user-id': 'admin'};
  }

  @override
  Future<void> createSalaryStructure(CreateSalaryStructureRequestDto request) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.compSalaryStructures,
        body: request.toJson(),
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create salary structure';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create salary structure: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateSalaryStructure({
    required String structureGuid,
    required CreateSalaryStructureRequestDto request,
  }) async {
    try {
      final response = await apiClient.put(
        ApiEndpoints.compSalaryStructureByGuid(structureGuid),
        body: request.toJson(),
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update salary structure';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update salary structure: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteSalaryStructure({required String structureGuid}) async {
    try {
      await apiClient.delete(ApiEndpoints.compSalaryStructureByGuid(structureGuid), headers: _buildHeaders());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete salary structure: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<SalaryStructurePageDto> getSalaryStructures({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? status,
  }) async {
    try {
      final queryParams = {
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (status != null) queryParams['status'] = status;

      final response = await apiClient.get(
        ApiEndpoints.compSalaryStructures,
        queryParameters: queryParams,
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch salary structures';
        throw ServerException(message, statusCode: 400);
      }

      return SalaryStructurePageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary structures: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<SalaryStructureDetailsDto> getSalaryStructureDetails({
    required int enterpriseId,
    required String structureGuid,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compSalaryStructureDetails(structureGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch salary structure details';
        throw ServerException(message, statusCode: 400);
      }

      return SalaryStructureDetailsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary structure details: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<SalaryStructureFullDetailsDto> getSalaryStructureFullDetails({
    required int enterpriseId,
    required String structureGuid,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compSalaryStructureDetails(structureGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch salary structure details';
        throw ServerException(message, statusCode: 400);
      }

      return SalaryStructureFullDetailsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary structure details: ${e.toString()}', originalError: e);
    }
  }
}
