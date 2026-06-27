import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';

class UpdateCandidateSession {
  const UpdateCandidateSession({required this.candidate, required this.enterpriseId});

  final Candidate candidate;
  final int enterpriseId;

  String get candidateGuid => candidate.candidateGuid;
}
