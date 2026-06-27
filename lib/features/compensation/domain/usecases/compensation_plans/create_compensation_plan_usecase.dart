import 'package:grc/features/compensation/data/dto/compensation_plans/create_compensation_plan_request_dto.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class CreateCompensationPlanUseCase {
  final CompensationPlansRepository repository;

  CreateCompensationPlanUseCase({required this.repository});

  Future<void> call({required CreateCompensationPlanRequestDto request}) {
    return repository.createCompensationPlan(request: request);
  }
}
