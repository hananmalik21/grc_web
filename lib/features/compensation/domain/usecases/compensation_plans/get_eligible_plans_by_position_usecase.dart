import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class GetEligiblePlansByPositionUseCase {
  final CompensationPlansRepository repository;

  GetEligiblePlansByPositionUseCase({required this.repository});

  Future<List<CompensationPlan>> call({required String positionId, required int enterpriseId}) {
    return repository.getEligiblePlansByPosition(positionId: positionId, enterpriseId: enterpriseId);
  }
}
