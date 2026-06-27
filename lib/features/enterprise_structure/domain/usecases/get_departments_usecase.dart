import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/department.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/department_repository.dart';

/// Use case for getting departments
class GetDepartmentsUseCase {
  final DepartmentRepository repository;

  GetDepartmentsUseCase({required this.repository});

  /// Executes the use case to get departments
  ///
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Returns a [PaginatedDepartments] with the list of departments and pagination info
  /// Throws [AppException] if the operation fails
  Future<PaginatedDepartments> call({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      return await repository.getDepartments(
        search: search,
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get departments: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

