import 'package:grc/features/hiring/presentation/models/candidate_data.dart';

class UpdateCandidateAssessmentArgs {
  const UpdateCandidateAssessmentArgs({required this.candidateGuid, required this.assessment});

  final String candidateGuid;
  final CandidateAssessmentData assessment;

  String get assessmentGuid => assessment.assessmentGuid;

  @override
  bool operator ==(Object other) {
    return other is UpdateCandidateAssessmentArgs &&
        other.candidateGuid == candidateGuid &&
        other.assessmentGuid == assessmentGuid;
  }

  @override
  int get hashCode => Object.hash(candidateGuid, assessmentGuid);
}
