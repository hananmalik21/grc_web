import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';

class ScheduleInterviewSubject {
  const ScheduleInterviewSubject({required this.candidateGuid, required this.displayName});

  final String candidateGuid;
  final String displayName;

  factory ScheduleInterviewSubject.fromCandidate(CandidateData candidate) {
    return ScheduleInterviewSubject(candidateGuid: candidate.id, displayName: candidate.name);
  }

  factory ScheduleInterviewSubject.fromApplicationDetail(ApplicationDetailData detail) {
    return ScheduleInterviewSubject(candidateGuid: detail.candidateGuid, displayName: detail.candidateName);
  }
}
