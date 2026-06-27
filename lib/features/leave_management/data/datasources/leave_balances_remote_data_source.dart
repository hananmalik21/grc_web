import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/leave_balance_summary_dto.dart';
import 'package:grc/features/leave_management/data/dto/paginated_leave_balances_dto.dart';

abstract class LeaveBalancesRemoteDataSource {
  Future<PaginatedLeaveBalancesDto> getLeaveBalances({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? employeeGuid,
  });

  Future<LeaveBalanceSummaryResponseDto> getLeaveBalanceSummaries({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? search,
  });

  Future<Map<String, dynamic>> updateLeaveBalance(
    String employeeLeaveBalanceGuid,
    Map<String, dynamic> body, {
    int? tenantId,
  });

  Future<List<LeaveBalanceDto>> getEmployeeLeaveBalances({required String employeeGuid, int? tenantId});

  Future<Map<String, dynamic>> adjustLeaveBalances(Map<String, dynamic> body, {int? tenantId});
}

class LeaveBalancesRemoteDataSourceImpl implements LeaveBalancesRemoteDataSource {
  final ApiClient apiClient;

  LeaveBalancesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedLeaveBalancesDto> getLeaveBalances({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? employeeGuid,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (tenantId != null) 'tenant_id': tenantId.toString(),
        if (employeeGuid != null && employeeGuid.isNotEmpty) 'employee_guid': employeeGuid,
      };

      final response = await apiClient.get(ApiEndpoints.absLeaveBalances, queryParameters: queryParameters);

      return PaginatedLeaveBalancesDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave balances: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<LeaveBalanceSummaryResponseDto> getLeaveBalanceSummaries({
    int page = 1,
    int pageSize = 10,
    int? tenantId,
    String? search,
  }) async {
    try {
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (tenantId != null) 'tenant_id': tenantId.toString(),
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      };
      final response = await apiClient.get(ApiEndpoints.absLeaveBalances, queryParameters: queryParameters);
      return LeaveBalanceSummaryResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave balance summaries: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateLeaveBalance(
    String employeeLeaveBalanceGuid,
    Map<String, dynamic> body, {
    int? tenantId,
  }) async {
    try {
      final queryParameters = <String, String>{if (tenantId != null) 'tenant_id': tenantId.toString()};
      return await apiClient.put(
        ApiEndpoints.absLeaveBalanceUpdate(employeeLeaveBalanceGuid),
        body: body,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update leave balance: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<LeaveBalanceDto>> getEmployeeLeaveBalances({required String employeeGuid, int? tenantId}) async {
    try {
      final queryParameters = <String, String>{
        'employee_guid': employeeGuid,
        if (tenantId != null) 'tenant_id': tenantId.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.absEmployeeLeaveBalances, queryParameters: queryParameters);

      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((e) => LeaveBalanceDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee leave balances: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> adjustLeaveBalances(Map<String, dynamic> body, {int? tenantId}) async {
    try {
      final requestBody = Map<String, dynamic>.from(body);
      if (tenantId != null) requestBody['tenant_id'] = tenantId;
      return await apiClient.post(ApiEndpoints.absLeaveBalancesAdjust, body: requestBody);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to adjust leave balances: ${e.toString()}', originalError: e);
    }
  }
}
