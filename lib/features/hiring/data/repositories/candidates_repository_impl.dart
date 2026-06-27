import 'dart:typed_data';

import 'package:grc/features/hiring/data/datasources/candidates_remote_data_source.dart';
import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/initiate_background_check_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/request_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/schedule_interview_input.dart';
import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';

class CandidatesRepositoryImpl implements CandidatesRepository {
  const CandidatesRepositoryImpl({required this.remoteDataSource});

  final CandidatesRemoteDataSource remoteDataSource;

  @override
  Future<CandidatesPage> getCandidates({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    final dto = await remoteDataSource.getCandidates(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
    return dto.toDomain();
  }

  @override
  Future<Candidate> getCandidateByGuid({required String candidateGuid, required int enterpriseId}) async {
    final dto = await remoteDataSource.getCandidateByGuid(candidateGuid: candidateGuid, enterpriseId: enterpriseId);
    return dto.toDomain();
  }

  @override
  Future<Map<String, dynamic>> createCandidate(CreateCandidateRequestInput input) {
    return remoteDataSource.createCandidate(input);
  }

  @override
  Future<Map<String, dynamic>> updateCandidate(UpdateCandidateRequestInput input) {
    return remoteDataSource.updateCandidate(input);
  }

  @override
  Future<Map<String, dynamic>> initiateBackgroundCheck(InitiateBackgroundCheckInput input) {
    return remoteDataSource.initiateBackgroundCheck(input);
  }

  @override
  Future<Map<String, dynamic>> scheduleInterview(ScheduleInterviewInput input) {
    return remoteDataSource.scheduleInterview(input);
  }

  @override
  Future<Map<String, dynamic>> requestAssessment(RequestAssessmentInput input) {
    return remoteDataSource.requestAssessment(input);
  }

  @override
  Future<Map<String, dynamic>> deleteCandidateAssessment(DeleteCandidateAssessmentInput input) {
    return remoteDataSource.deleteCandidateAssessment(input);
  }

  @override
  Future<Map<String, dynamic>> deleteCandidate(DeleteCandidateInput input) {
    return remoteDataSource.deleteCandidate(input);
  }

  @override
  Future<Map<String, dynamic>> updateCandidateAssessment(UpdateCandidateAssessmentInput input) {
    return remoteDataSource.updateCandidateAssessment(input);
  }

  @override
  Future<Uint8List> getResumeBytes({required String resumeLink}) {
    return remoteDataSource.getResumeBytes(resumeLink: resumeLink);
  }
}
