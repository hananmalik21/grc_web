import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/eligible_plans_criteria.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class GetEligiblePlansByCriteriaUseCase {
  final CompensationPlansRepository repository;

  GetEligiblePlansByCriteriaUseCase({required this.repository});

  Future<List<CompensationPlan>> call({required EligiblePlansCriteria criteria}) async {
    return repository.getEligiblePlansByCriteria(criteria: criteria);
  }
}
