import 'dart:typed_data';

import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/initiate_background_check_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/request_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/schedule_interview_input.dart';

abstract class CandidatesRepository {
  Future<CandidatesPage> getCandidates({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Candidate> getCandidateByGuid({required String candidateGuid, required int enterpriseId});

  Future<Map<String, dynamic>> createCandidate(CreateCandidateRequestInput input);

  Future<Map<String, dynamic>> updateCandidate(UpdateCandidateRequestInput input);

  Future<Map<String, dynamic>> initiateBackgroundCheck(InitiateBackgroundCheckInput input);

  Future<Map<String, dynamic>> scheduleInterview(ScheduleInterviewInput input);

  Future<Map<String, dynamic>> requestAssessment(RequestAssessmentInput input);

  Future<Map<String, dynamic>> deleteCandidateAssessment(DeleteCandidateAssessmentInput input);

  Future<Map<String, dynamic>> deleteCandidate(DeleteCandidateInput input);

  Future<Map<String, dynamic>> updateCandidateAssessment(UpdateCandidateAssessmentInput input);

  Future<Uint8List> getResumeBytes({required String resumeLink});
}
