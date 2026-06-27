import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/bulk_adjustments/bulk_eligible_plans_dto.dart';
import 'package:grc/features/compensation/data/dto/bulk_adjustments/bulk_employee_components_page_dto.dart';
import 'package:grc/features/compensation/data/dto/bulk_adjustments/create_bulk_adjustment_request_dto.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/create_bulk_adjustment_request.dart';

abstract class BulkAdjustmentsRemoteDataSource {
  Future<BulkEmployeeComponentsPageDto> getBulkEmployeeComponents({
    required int enterpriseId,
    required List<String> employeeGuids,
    required int page,
    required int pageSize,
  });

  Future<BulkEligiblePlansDto> getEligiblePlans({required List<String> employeeGuids});

  Future<void> createBulkAdjustment({required CreateBulkAdjustmentRequest request});
}

class BulkAdjustmentsRemoteDataSourceImpl implements BulkAdjustmentsRemoteDataSource {
  BulkAdjustmentsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<BulkEmployeeComponentsPageDto> getBulkEmployeeComponents({
    required int enterpriseId,
    required List<String> employeeGuids,
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.compBulkEmployeeComponents,
        body: {'enterprise_id': enterpriseId, 'employee_guids': employeeGuids, 'page': page, 'page_size': pageSize},
      );

      final success = response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to fetch bulk employee components';
        throw ServerException(message, statusCode: 400);
      }

      return BulkEmployeeComponentsPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch bulk employee components: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<BulkEligiblePlansDto> getEligiblePlans({required List<String> employeeGuids}) async {
    try {
      final response = await apiClient.post(ApiEndpoints.compEligiblePlans, body: {'employee_guids': employeeGuids});

      final success = response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to fetch eligible plans';
        throw ServerException(message, statusCode: 400);
      }

      return BulkEligiblePlansDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch eligible plans: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createBulkAdjustment({required CreateBulkAdjustmentRequest request}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.compBulkAdjustments,
        body: CreateBulkAdjustmentRequestDto(request: request).toJson(),
      );

      final success = response['success'] as bool? ?? response['status'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to create bulk adjustment';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create bulk adjustment: ${e.toString()}', originalError: e);
    }
  }
}
