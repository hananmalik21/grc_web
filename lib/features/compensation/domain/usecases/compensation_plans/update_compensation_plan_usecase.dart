import 'package:grc/features/compensation/data/dto/compensation_plans/create_compensation_plan_request_dto.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class UpdateCompensationPlanUseCase {
  final CompensationPlansRepository repository;

  UpdateCompensationPlanUseCase({required this.repository});

  Future<void> call({
    required String planGuid,
    required CreateCompensationPlanRequestDto request,
  }) async {
    return repository.updateCompensationPlan(planGuid: planGuid, request: request);
  }
}
