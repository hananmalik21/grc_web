import 'dart:typed_data';

import 'package:grc/features/compensation/domain/repositories/employees/employees_repository.dart';

class CreateSalaryAdjustmentUseCase {
  final EmployeesRepository repository;

  CreateSalaryAdjustmentUseCase({required this.repository});

  Future<void> call({
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
    return repository.createSalaryAdjustment(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      planId: planId,
      adjustmentType: adjustmentType,
      effectiveDate: effectiveDate,
      status: status,
      reasonCode: reasonCode,
      budgetCode: budgetCode,
      justificationText: justificationText,
      performanceRating: performanceRating,
      internalNotes: internalNotes,
      updatedBy: updatedBy,
      components: components,
      documentPath: documentPath,
      documentName: documentName,
      documentBytes: documentBytes,
    );
  }
}
