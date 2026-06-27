import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/leave_balance_transactions_dto.dart';

abstract class LeaveBalanceTransactionsRemoteDataSource {
  Future<LeaveBalanceTransactionsResponseDto> getTransactions({
    required String employeeGuid,
    required int leaveTypeId,
    required int enterpriseId,
    required int page,
    required int pageSize,
    int? tenantId,
  });
}

class LeaveBalanceTransactionsRemoteDataSourceImpl implements LeaveBalanceTransactionsRemoteDataSource {
  LeaveBalanceTransactionsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<LeaveBalanceTransactionsResponseDto> getTransactions({
    required String employeeGuid,
    required int leaveTypeId,
    required int enterpriseId,
    required int page,
    required int pageSize,
    int? tenantId,
  }) async {
    try {
      final queryParameters = <String, String>{
        'employee_guid': employeeGuid,
        'leave_type_id': leaveTypeId.toString(),
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (tenantId != null) 'tenant_id': tenantId.toString(),
      };
      final response = await apiClient.get(ApiEndpoints.absLeaveBalanceTransactions, queryParameters: queryParameters);
      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch transactions';
        throw ServerException(message, statusCode: 400);
      }
      return LeaveBalanceTransactionsResponseDto.fromJson(Map<String, dynamic>.from(response));
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave balance transactions: ${e.toString()}', originalError: e);
    }
  }
}
