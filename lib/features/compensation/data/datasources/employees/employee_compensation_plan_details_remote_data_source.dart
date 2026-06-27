import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/employees/employee_compensation_plan_details_dto.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';

abstract class EmployeeCompensationPlanDetailsRemoteDataSource {
  Future<EmployeeCompensationPlanDetails> getEmployeeCompensationPlanDetails({
    required int enterpriseId,
    required String employeeGuid,
    required String planGuid,
  });
}

class EmployeeCompensationPlanDetailsRemoteDataSourceImpl implements EmployeeCompensationPlanDetailsRemoteDataSource {
  const EmployeeCompensationPlanDetailsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<EmployeeCompensationPlanDetails> getEmployeeCompensationPlanDetails({
    required int enterpriseId,
    required String employeeGuid,
    required String planGuid,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'employee_guid': employeeGuid,
        'plan_guid': planGuid,
      };

      final response = await apiClient.get(
        ApiEndpoints.compEmployeeCompensationPlanDetails,
        queryParameters: queryParameters,
      );

      final success = response['status'] as bool? ?? response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to fetch employee compensation plan details';
        throw ServerException(message, statusCode: 400);
      }

      final data = (response['data'] as Map<String, dynamic>?) ?? const <String, dynamic>{};
      return EmployeeCompensationPlanDetailsDto.fromJson(data).toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee compensation plan details: ${e.toString()}', originalError: e);
    }
  }
}
