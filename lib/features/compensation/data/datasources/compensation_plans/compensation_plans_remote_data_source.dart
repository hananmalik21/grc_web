import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/compensation_plans/compensation_plans_page_dto.dart';
import 'package:grc/features/compensation/data/dto/compensation_plans/compensation_plan_dto.dart';
import 'package:grc/features/compensation/data/dto/compensation_plans/create_compensation_plan_request_dto.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/eligible_plans_criteria.dart';

abstract class CompensationPlansRemoteDataSource {
  Future<CompensationPlansPageDto> getCompensationPlans({
    required int enterpriseId,
    required int page,
    required int limit,
    String? search,
    String? planTypeCode,
    String? currencyCode,
    String? statusCode,
  });

  Future<CompensationPlanDto> getCompensationPlanDetail({required String planGuid});
  Future<List<CompensationPlanDto>> getEligiblePlansForEmployee({required String employeeGuid});
  Future<List<CompensationPlanDto>> getEligiblePlansByCriteria({required EligiblePlansCriteria criteria});
  Future<List<CompensationPlanDto>> getEligiblePlansByPosition({required String positionId, required int enterpriseId});
  Future<void> createCompensationPlan({required CreateCompensationPlanRequestDto request});
  Future<void> createEmployeeCompensation({required Map<String, dynamic> request});

  Future<void> updateCompensationPlan({required String planGuid, required CreateCompensationPlanRequestDto request});
  Future<void> deleteCompensationPlan({required String planGuid});
}

class CompensationPlansRemoteDataSourceImpl implements CompensationPlansRemoteDataSource {
  final ApiClient apiClient;

  CompensationPlansRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders() {
    return {'x-user-id': 'admin'};
  }

  @override
  Future<CompensationPlanDto> getCompensationPlanDetail({required String planGuid}) async {
    try {
      final endpoint = ApiEndpoints.compPlanDetails(planGuid);
      final response = await apiClient.get(endpoint, headers: _buildHeaders());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch compensation plan details';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data found in response', statusCode: 404);
      }

      return CompensationPlanDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch compensation plan details: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompensationPlanDto>> getEligiblePlansForEmployee({required String employeeGuid}) async {
    try {
      final endpoint = ApiEndpoints.eligiblePlansForEmployee(employeeGuid);
      final response = await apiClient.get(endpoint, headers: _buildHeaders());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch eligible plans';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['plans'] as List<dynamic>?;
      if (data == null) return [];

      return data.map((e) => CompensationPlanDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompensationPlanDto>> getEligiblePlansByCriteria({required EligiblePlansCriteria criteria}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compEligiblePlansByCriteria,
        queryParameters: {
          'enterprise_id': criteria.enterpriseId.toString(),
          'grade_id': criteria.gradeId.toString(),
          'position_id': criteria.positionId,
          'job_family_id': criteria.jobFamilyId.toString(),
          'org_unit_id': criteria.orgUnitId,
        },
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch eligible plans';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>?;
      if (data == null) return [];

      return data.map((e) => CompensationPlanDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans by criteria: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompensationPlanDto>> getEligiblePlansByPosition({
    required String positionId,
    required int enterpriseId,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compEligiblePlansByPosition,
        queryParameters: {'position_id': positionId, 'enterprise_id': enterpriseId.toString()},
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch eligible plans';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>?;
      if (data == null) return [];

      return data.map((e) => CompensationPlanDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans by position: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompensationPlansPageDto> getCompensationPlans({
    required int enterpriseId,
    required int page,
    required int limit,
    String? search,
    String? planTypeCode,
    String? currencyCode,
    String? statusCode,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final normalizedSearch = search?.trim();
      final normalizedPlanTypeCode = planTypeCode?.trim();
      final normalizedCurrencyCode = currencyCode?.trim();
      final normalizedStatusCode = statusCode?.trim();

      if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
        queryParameters['search'] = normalizedSearch;
      }
      if (normalizedPlanTypeCode != null && normalizedPlanTypeCode.isNotEmpty) {
        queryParameters['plan_type_code'] = normalizedPlanTypeCode;
      }
      if (normalizedCurrencyCode != null && normalizedCurrencyCode.isNotEmpty) {
        queryParameters['currency_code'] = normalizedCurrencyCode;
      }
      if (normalizedStatusCode != null && normalizedStatusCode.isNotEmpty) {
        queryParameters['status_code'] = normalizedStatusCode;
      }

      final response = await apiClient.get(
        ApiEndpoints.compPlans,
        queryParameters: queryParameters,
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch compensation plans';
        throw ServerException(message, statusCode: 400);
      }

      return CompensationPlansPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch compensation plans: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createCompensationPlan({required CreateCompensationPlanRequestDto request}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.compensationPlansCreate,
        body: request.toJson(),
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create compensation plan';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create compensation plan: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createEmployeeCompensation({required Map<String, dynamic> request}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.createEmployeeCompensation,
        body: request,
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create employee compensation';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create employee compensation: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateCompensationPlan({
    required String planGuid,
    required CreateCompensationPlanRequestDto request,
  }) async {
    try {
      final body = request.toJson()..['plan_guid'] = planGuid;
      final response = await apiClient.put(ApiEndpoints.compPlanUpdate, body: body, headers: _buildHeaders());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update compensation plan';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update compensation plan: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteCompensationPlan({required String planGuid}) async {
    try {
      final endpoint = '${ApiEndpoints.compensationPlans}/$planGuid';
      final requestBody = {'deleted_by': 'ADMIN'};
      final response = await apiClient.delete(endpoint, body: requestBody);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to delete compensation plan';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete compensation plan: ${e.toString()}', originalError: e);
    }
  }
}
