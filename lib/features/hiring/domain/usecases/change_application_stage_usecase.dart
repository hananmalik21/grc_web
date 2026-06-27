import 'package:grc/features/hiring/domain/models/applications/change_application_stage_input.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';

class ChangeApplicationStageUseCase {
  const ChangeApplicationStageUseCase({required this.repository});

  final ApplicationsRepository repository;

  Future<Map<String, dynamic>> call(ChangeApplicationStageInput input) {
    return repository.changeApplicationStage(input);
  }
}
