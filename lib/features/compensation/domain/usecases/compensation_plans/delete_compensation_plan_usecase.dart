import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class DeleteCompensationPlanUseCase {
  final CompensationPlansRepository repository;

  DeleteCompensationPlanUseCase({required this.repository});

  Future<void> call({required String planGuid}) {
    return repository.deleteCompensationPlan(planGuid: planGuid);
  }
}
