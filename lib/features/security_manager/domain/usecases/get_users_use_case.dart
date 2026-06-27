import '../models/users_paginated_result.dart';
import '../repositories/user_management_repository.dart';

class GetUsersUseCase {
  final UserManagementRepository repository;

  GetUsersUseCase(this.repository);

  Future<UsersPaginatedResult> call({int? enterpriseId, int page = 1, int limit = 10, String? searchQuery}) async {
    if (enterpriseId == null) return UsersPaginatedResult.empty;
    return repository.getUsers(enterpriseId: enterpriseId, page: page, limit: limit, searchQuery: searchQuery);
  }
}
