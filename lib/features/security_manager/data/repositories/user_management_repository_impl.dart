import '../datasources/user_management_remote_data_source.dart';
import '../../domain/models/employee_details.dart';
import '../../domain/models/user_detail_data.dart';
import '../../domain/models/users_paginated_result.dart';
import '../../domain/repositories/user_management_repository.dart';

class UserManagementRepositoryImpl implements UserManagementRepository {
  const UserManagementRepositoryImpl(this._remoteDataSource);

  final UserManagementRemoteDataSource _remoteDataSource;

  @override
  Future<UsersPaginatedResult> getUsers({
    required int enterpriseId,
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    return _remoteDataSource.getUsers(enterpriseId: enterpriseId, page: page, limit: limit, searchQuery: searchQuery);
  }

  @override
  Future<EmployeeDetails> getEmployeeDetails({required String employeeGuid, int? enterpriseId}) async {
    return _remoteDataSource.getEmployeeDetails(employeeGuid: employeeGuid, enterpriseId: enterpriseId);
  }

  @override
  Future<UserDetailData> getUserDetail({required String userGuid}) async {
    return _remoteDataSource.getUserDetail(userGuid: userGuid);
  }

  @override
  Future<void> createUser({required Map<String, dynamic> body}) async {
    return _remoteDataSource.createUser(body: body);
  }

  @override
  Future<void> updateUser({required Map<String, dynamic> body}) async {
    return _remoteDataSource.updateUser(body: body);
  }

  @override
  Future<void> deleteUser({required String userGuid}) async {
    return _remoteDataSource.deleteUser(userGuid: userGuid);
  }
}
