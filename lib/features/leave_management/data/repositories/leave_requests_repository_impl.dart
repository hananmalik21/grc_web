import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/leave_requests_remote_data_source.dart';
import 'package:grc/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:grc/features/leave_management/domain/models/employee_leave_stats.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_requests_repository.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';

class LeaveRequestsRepositoryImpl implements LeaveRequestsRepository {
  final LeaveRequestsRemoteDataSource remoteDataSource;

  LeaveRequestsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedLeaveRequests> getLeaveRequests({
    int page = 1,
    int pageSize = 10,
    String? status,
    int? tenantId,
  }) async {
    try {
      final dto = await remoteDataSource.getLeaveRequests(
        page: page,
        pageSize: pageSize,
        status: status,
        tenantId: tenantId,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave requests: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<PaginatedLeaveRequests> getEmployeeLeaveRequests({
    required String employeeGuid,
    int page = 1,
    int pageSize = 10,
    int? tenantId,
  }) async {
    try {
      final dto = await remoteDataSource.getEmployeeLeaveRequests(
        employeeGuid: employeeGuid,
        page: page,
        pageSize: pageSize,
        tenantId: tenantId,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: Failed to fetch employee leave requests: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<EmployeeLeaveStats> getEmployeeLeaveRequestStats({required String employeeGuid, int? tenantId}) async {
    try {
      final dto = await remoteDataSource.getEmployeeLeaveRequestStats(employeeGuid: employeeGuid, tenantId: tenantId);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: Failed to fetch employee leave request stats: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getLeaveRequestById(String guid, {int? tenantId}) async {
    try {
      return await remoteDataSource.getLeaveRequestById(guid, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> approveLeaveRequest(String guid, {int? tenantId}) async {
    try {
      return await remoteDataSource.approveLeaveRequest(guid, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to approve leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectLeaveRequest(String guid, {int? tenantId}) async {
    try {
      return await remoteDataSource.rejectLeaveRequest(guid, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to reject leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit, {int? tenantId}) async {
    try {
      return await remoteDataSource.createLeaveRequest(state, submit, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to create leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteLeaveRequest(String guid, {int? tenantId}) async {
    try {
      return await remoteDataSource.deleteLeaveRequest(guid, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to delete leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateLeaveRequest(
    String guid,
    NewLeaveRequestState state,
    bool submit, {
    int? tenantId,
  }) async {
    try {
      return await remoteDataSource.updateLeaveRequest(guid, state, submit, tenantId: tenantId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to update leave request: ${e.toString()}', originalError: e);
    }
  }
}
