import '../../repositories/compensation_plans/compensation_plans_repository.dart';
import '../../models/compensation_plans/compensation_plan.dart';

class GetCompensationPlanDetailUseCase {
  final CompensationPlansRepository repository;

  GetCompensationPlanDetailUseCase({required this.repository});

  Future<CompensationPlan> call({required String planGuid}) async {
    return repository.getCompensationPlanDetail(planGuid: planGuid);
  }
}
