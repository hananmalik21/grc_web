import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/department.dart';

/// Repository interface for department operations
abstract class DepartmentRepository {
  /// Gets paginated list of departments
  ///
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedDepartments> getDepartments({
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Creates a new department
  ///
  /// Throws [AppException] if the operation fails
  Future<DepartmentOverview> createDepartment(Map<String, dynamic> departmentData);

  /// Updates an existing department
  ///
  /// Throws [AppException] if the operation fails
  Future<DepartmentOverview> updateDepartment(int departmentId, Map<String, dynamic> departmentData);

  /// Deletes a department
  ///
  /// [hard] - If true, permanently deletes the department. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> deleteDepartment(int departmentId, {bool hard = true});
}

