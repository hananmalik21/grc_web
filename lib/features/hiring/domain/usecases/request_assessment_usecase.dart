import 'package:grc/features/hiring/domain/models/candidates/request_assessment_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class RequestAssessmentUseCase {
  const RequestAssessmentUseCase({required this.repository});

  final CandidatesRepository repository;

  Future<Map<String, dynamic>> call(RequestAssessmentInput input) {
    return repository.requestAssessment(input);
  }
}
