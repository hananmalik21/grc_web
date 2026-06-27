import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/department_repository.dart';

/// Use case for deleting an existing department
class DeleteDepartmentUseCase {
  final DepartmentRepository repository;

  DeleteDepartmentUseCase({required this.repository});

  /// Executes the use case to delete a department
  ///
  /// [departmentId] - The ID of the department to delete.
  /// [hard] - If true, permanently deletes the department. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> call(int departmentId, {bool hard = true}) async {
    try {
      await repository.deleteDepartment(departmentId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete department: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

