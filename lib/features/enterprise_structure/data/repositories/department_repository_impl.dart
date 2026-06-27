import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/department_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/department.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/department_repository.dart';

/// Implementation of DepartmentRepository
class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDataSource remoteDataSource;

  DepartmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedDepartments> getDepartments({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final dto = await remoteDataSource.getDepartments(
        search: search,
        page: page,
        pageSize: pageSize,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<DepartmentOverview> createDepartment(Map<String, dynamic> departmentData) async {
    try {
      final dto = await remoteDataSource.createDepartment(departmentData);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<DepartmentOverview> updateDepartment(int departmentId, Map<String, dynamic> departmentData) async {
    try {
      final dto = await remoteDataSource.updateDepartment(departmentId, departmentData);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteDepartment(int departmentId, {bool hard = true}) async {
    try {
      await remoteDataSource.deleteDepartment(departmentId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

