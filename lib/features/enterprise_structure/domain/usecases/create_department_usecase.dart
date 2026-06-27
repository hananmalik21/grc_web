import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/department.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/department_repository.dart';

/// Use case for creating a new department
class CreateDepartmentUseCase {
  final DepartmentRepository repository;

  CreateDepartmentUseCase({required this.repository});

  /// Executes the use case to create a department
  ///
  /// Returns the created [DepartmentOverview]
  /// Throws [AppException] if the operation fails
  Future<DepartmentOverview> call(Map<String, dynamic> departmentData) async {
    try {
      return await repository.createDepartment(departmentData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create department: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

