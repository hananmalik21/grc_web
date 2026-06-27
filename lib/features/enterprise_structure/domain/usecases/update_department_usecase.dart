import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/department.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/department_repository.dart';

/// Use case for updating an existing department
class UpdateDepartmentUseCase {
  final DepartmentRepository repository;

  UpdateDepartmentUseCase({required this.repository});

  /// Executes the use case to update a department
  ///
  /// Returns the updated [DepartmentOverview]
  /// Throws [AppException] if the operation fails
  Future<DepartmentOverview> call(int departmentId, Map<String, dynamic> departmentData) async {
    try {
      return await repository.updateDepartment(departmentId, departmentData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update department: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

