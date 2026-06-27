import 'package:grc/features/hiring/domain/models/candidates/initiate_background_check_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class InitiateBackgroundCheckUseCase {
  const InitiateBackgroundCheckUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(InitiateBackgroundCheckInput input) {
    return repository.initiateBackgroundCheck(input);
  }
}
