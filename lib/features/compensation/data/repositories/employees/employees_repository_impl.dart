import 'dart:convert';
import 'dart:typed_data';
import 'package:grc/features/compensation/data/datasources/employees/compensation_employees_remote_data_source.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_adjustment_details.dart';
import 'package:grc/features/compensation/domain/models/employees/employees_page.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employees_repository.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final CompensationEmployeesRemoteDataSource remoteDataSource;

  EmployeesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<EmployeesPage> getEmployees({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    final dto = await remoteDataSource.getEmployees(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: search,
    );
    return dto.toDomain();
  }

  @override
  Future<List<EmployeeAssignedComponent>> getEmployeeAssignedComponents({required String employeeGuid}) async {
    final list = await remoteDataSource.getEmployeeAssignedComponents(employeeGuid: employeeGuid);
    return list.map((e) => EmployeeAssignedComponent.fromJson(e)).toList();
  }

  @override
  Future<EmployeeAdjustmentDetails> getEmployeeAdjustmentDetails({
    required String employeeGuid,
    required int enterpriseId,
  }) async {
    final response = await remoteDataSource.getEmployeeAdjustmentDetails(
      employeeGuid: employeeGuid,
      enterpriseId: enterpriseId,
    );
    return EmployeeAdjustmentDetails.fromApi(response);
  }

  @override
  Future<void> createSalaryAdjustment({
    required int enterpriseId,
    required int employeeId,
    required int planId,
    required String adjustmentType,
    required DateTime effectiveDate,
    required String status,
    required String reasonCode,
    required String budgetCode,
    required String justificationText,
    required String performanceRating,
    required String internalNotes,
    required String updatedBy,
    required List<Map<String, dynamic>> components,
    String? documentPath,
    String? documentName,
    Uint8List? documentBytes,
  }) async {
    final componentsJson = jsonEncode(components);
    final formattedDate = effectiveDate.toIso8601String().split('T').first;

    await remoteDataSource.createSalaryAdjustment(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      planId: planId,
      adjustmentType: adjustmentType,
      effectiveDate: formattedDate,
      status: status,
      reasonCode: reasonCode,
      budgetCode: budgetCode,
      justificationText: justificationText,
      performanceRating: performanceRating,
      internalNotes: internalNotes,
      updatedBy: updatedBy,
      componentsJson: componentsJson,
      documentPath: documentPath,
      documentName: documentName,
      documentBytes: documentBytes,
    );
  }
}
