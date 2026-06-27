import 'package:grc/features/compensation/domain/models/employee_compensation/create_employee_compensation_request.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class CreateEmployeeCompensationUseCase {
  final CompensationPlansRepository repository;

  CreateEmployeeCompensationUseCase({required this.repository});

  Future<void> call({required CreateEmployeeCompensationRequest request}) async {
    return await repository.createEmployeeCompensation(request: request);
  }
}
