import 'dart:typed_data';

import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/employees/employees_page_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class CompensationEmployeesRemoteDataSource {
  Future<EmployeesPageDto> getEmployees({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  });

  Future<List<Map<String, dynamic>>> getEmployeeAssignedComponents({required String employeeGuid});

  Future<Map<String, dynamic>> getEmployeeAdjustmentDetails({required String employeeGuid, required int enterpriseId});

  Future<void> createSalaryAdjustment({
    required int enterpriseId,
    required int employeeId,
    required int planId,
    required String adjustmentType,
    required String effectiveDate,
    required String status,
    required String reasonCode,
    required String budgetCode,
    required String justificationText,
    required String performanceRating,
    required String internalNotes,
    required String updatedBy,
    required String componentsJson,
    String? documentPath,
    String? documentName,
    Uint8List? documentBytes,
  });
}

class CompensationEmployeesRemoteDataSourceImpl implements CompensationEmployeesRemoteDataSource {
  final ApiClient apiClient;

  CompensationEmployeesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<EmployeesPageDto> getEmployees({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final normalizedSearch = search?.trim();
      if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
        queryParameters['search'] = normalizedSearch;
      }

      final response = await apiClient.get(ApiEndpoints.compEmployeeCompensations, queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch employees';
        throw ServerException(message, statusCode: 400);
      }

      return EmployeesPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employees: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getEmployeeAssignedComponents({required String employeeGuid}) async {
    try {
      final queryParameters = {'employee_guid': employeeGuid};
      final response = await apiClient.get(
        ApiEndpoints.compEmployeeAssignedComponents,
        queryParameters: queryParameters,
      );

      final success = response['status'] as bool? ?? response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to fetch assigned components';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>?;
      return data?.map((e) => e as Map<String, dynamic>).toList() ?? [];
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch assigned components: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> getEmployeeAdjustmentDetails({
    required String employeeGuid,
    required int enterpriseId,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.employeeFullDetails(employeeGuid),
        headers: {'x-enterprise-id': enterpriseId.toString()},
      );
      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee details: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createSalaryAdjustment({
    required int enterpriseId,
    required int employeeId,
    required int planId,
    required String adjustmentType,
    required String effectiveDate,
    required String status,
    required String reasonCode,
    required String budgetCode,
    required String justificationText,
    required String performanceRating,
    required String internalNotes,
    required String updatedBy,
    required String componentsJson,
    String? documentPath,
    String? documentName,
    Uint8List? documentBytes,
  }) async {
    try {
      final formDataMap = <String, dynamic>{
        'enterprise_id': enterpriseId,
        'employee_id': employeeId,
        'plan_id': planId,
        'adjustment_type': adjustmentType,
        'effective_date': effectiveDate,
        'status': status,
        'reason_code': reasonCode,
        'budget_code': budgetCode,
        'justification_text': justificationText,
        'performance_rating': performanceRating,
        'internal_notes': internalNotes,
        'updated_by': updatedBy,
        'components': componentsJson,
      };

      final filename = documentName ?? documentPath?.split('/').last;
      if (filename != null && filename.isNotEmpty) {
        if (kIsWeb && documentBytes != null) {
          formDataMap['documents'] = MultipartFile.fromBytes(documentBytes, filename: filename);
        } else if (!kIsWeb && documentPath != null && documentPath.isNotEmpty) {
          formDataMap['documents'] = await MultipartFile.fromFile(documentPath, filename: filename);
        }
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await apiClient.postMultipart(ApiEndpoints.compEmployeeCompensationEdit, formData: formData);

      final statusResponse = response['status'] as bool? ?? response['success'] as bool? ?? false;
      if (!statusResponse) {
        final message = response['message'] as String? ?? 'Failed to create salary adjustment';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create salary adjustment: ${e.toString()}', originalError: e);
    }
  }
}
