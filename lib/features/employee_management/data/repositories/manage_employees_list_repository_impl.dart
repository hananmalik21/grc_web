import 'package:grc/features/employee_management/data/datasources/manage_employees_remote_data_source.dart';
import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/update_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:grc/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';

class ManageEmployeesListRepositoryImpl implements ManageEmployeesListRepository {
  final ManageEmployeesRemoteDataSource remoteDataSource;

  ManageEmployeesListRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ManageEmployeesPageResult> getEmployees({
    required int enterpriseId,
    int page = 1,
    int pageSize = 10,
    String? search,
    String? assignmentStatus,
    String? positionId,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    String? orgUnitId,
    String? levelCode,
  }) async {
    final dto = await remoteDataSource.getEmployees(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: search,
      assignmentStatus: assignmentStatus,
      positionId: positionId,
      jobFamilyId: jobFamilyId,
      jobLevelId: jobLevelId,
      gradeId: gradeId,
      orgUnitId: orgUnitId,
      levelCode: levelCode,
    );
    return dto.toDomain();
  }

  @override
  Future<EmployeeFullDetails?> getEmployeeFullDetails(String employeeGuid, {required int enterpriseId}) async {
    return remoteDataSource.getEmployeeFullDetails(employeeGuid, enterpriseId: enterpriseId);
  }

  @override
  Future<Map<String, dynamic>> createEmployee(
    CreateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
  }) async {
    return remoteDataSource.createEmployee(request, document: document, documentTypeCode: documentTypeCode);
  }

  @override
  Future<Map<String, dynamic>> updateEmployee(
    String employeeGuid,
    UpdateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
    String? docAction,
    int? replaceDocumentId,
  }) async {
    return remoteDataSource.updateEmployee(
      employeeGuid,
      request,
      document: document,
      documentTypeCode: documentTypeCode,
      docAction: docAction,
      replaceDocumentId: replaceDocumentId,
    );
  }
}
