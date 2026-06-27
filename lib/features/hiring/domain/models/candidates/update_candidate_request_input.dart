import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';

class UpdateCandidateRequestInput {
  const UpdateCandidateRequestInput({required this.candidateGuid, required this.payload});

  final String candidateGuid;
  final CreateCandidateRequestInput payload;
}
