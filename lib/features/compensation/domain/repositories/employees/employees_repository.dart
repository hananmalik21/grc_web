import 'dart:typed_data';

import '../../models/employees/employee_assigned_component.dart';
import '../../models/employees/employee_adjustment_details.dart';
import '../../models/employees/employees_page.dart';

abstract class EmployeesRepository {
  Future<EmployeesPage> getEmployees({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  });

  Future<List<EmployeeAssignedComponent>> getEmployeeAssignedComponents({required String employeeGuid});

  Future<EmployeeAdjustmentDetails> getEmployeeAdjustmentDetails({
    required String employeeGuid,
    required int enterpriseId,
  });

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
  });
}
