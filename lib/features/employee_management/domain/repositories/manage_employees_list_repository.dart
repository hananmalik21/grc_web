import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/update_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/domain/models/manage_employees_page_result.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';

abstract class ManageEmployeesListRepository {
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
  });

  Future<EmployeeFullDetails?> getEmployeeFullDetails(String employeeGuid, {required int enterpriseId});

  Future<Map<String, dynamic>> createEmployee(
    CreateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
  });

  Future<Map<String, dynamic>> updateEmployee(
    String employeeGuid,
    UpdateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
    String? docAction,
    int? replaceDocumentId,
  });
}
