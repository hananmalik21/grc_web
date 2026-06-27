import '../models/employee_details.dart';
import '../models/user_detail_data.dart';
import '../models/users_paginated_result.dart';

abstract class UserManagementRepository {
  Future<UsersPaginatedResult> getUsers({required int enterpriseId, int page = 1, int limit = 10, String? searchQuery});

  Future<EmployeeDetails> getEmployeeDetails({required String employeeGuid, int? enterpriseId});

  Future<UserDetailData> getUserDetail({required String userGuid});

  Future<void> createUser({required Map<String, dynamic> body});

  Future<void> updateUser({required Map<String, dynamic> body});

  Future<void> deleteUser({required String userGuid});
}
