import 'dart:typed_data';

import 'package:grc/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/candidates_dto.dart';
import 'package:grc/features/hiring/data/services/create_candidate_multipart_form_service.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_request_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/initiate_background_check_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/request_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/update_candidate_assessment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/schedule_interview_input.dart';

abstract class CandidatesRemoteDataSource {
  Future<CandidatesPageDto> getCandidates({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<CandidateDto> getCandidateByGuid({required String candidateGuid, required int enterpriseId});

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

class CandidatesRemoteDataSourceImpl implements CandidatesRemoteDataSource {
  const CandidatesRemoteDataSourceImpl({
    required this.apiClient,
    CreateCandidateMultipartFormService? multipartFormService,
  }) : _multipartFormService = multipartFormService ?? const CreateCandidateMultipartFormService();

  final ApiClient apiClient;
  final CreateCandidateMultipartFormService _multipartFormService;

  @override
  Future<CandidatesPageDto> getCandidates({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.recCandidates, queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch candidates';
        throw ServerException(message, statusCode: 400);
      }

      return CandidatesPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch candidates: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CandidateDto> getCandidateByGuid({required String candidateGuid, required int enterpriseId}) async {
    try {
      if (candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final response = await apiClient.get(
        ApiEndpoints.recCandidateByGuid(candidateGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch candidate';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw ServerException('No data found in response', statusCode: 404);
      }

      return CandidateDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch candidate: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createCandidate(CreateCandidateRequestInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final formData = await _multipartFormService.build(input);
      final response = await apiClient.postMultipart(ApiEndpoints.recCandidates, formData: formData);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create candidate';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create candidate: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateCandidate(UpdateCandidateRequestInput input) async {
    try {
      if (input.candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (input.payload.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final formData = await _multipartFormService.build(input.payload);
      final response = await apiClient.putMultipart(
        ApiEndpoints.recCandidateByGuid(input.candidateGuid),
        formData: formData,
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update candidate';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update candidate: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> initiateBackgroundCheck(InitiateBackgroundCheckInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }

      final response = await apiClient.post(ApiEndpoints.recCandidatesBackgroundCheck, body: input.toJson());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to initiate background check';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to initiate background check: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> scheduleInterview(ScheduleInterviewInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (input.interviewers.isEmpty) {
        throw ValidationException('interviewers is required');
      }

      final response = await apiClient.post(ApiEndpoints.recCandidatesInterviews, body: input.toJson());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to schedule interview';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to schedule interview: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> requestAssessment(RequestAssessmentInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (input.assessmentType.trim().isEmpty) {
        throw ValidationException('assessment_type is required');
      }
      if (input.platform.trim().isEmpty) {
        throw ValidationException('platform is required');
      }
      if (input.difficultyLevel.trim().isEmpty) {
        throw ValidationException('difficulty_level is required');
      }
      if (input.durationMinutes <= 0) {
        throw ValidationException('duration_minutes must be greater than 0');
      }
      if (input.completionDueDate.trim().isEmpty) {
        throw ValidationException('completion_due_date is required');
      }

      final response = await apiClient.post(ApiEndpoints.recCandidatesAssessments, body: input.toJson());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to send assessment request';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to send assessment request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteCandidate(DeleteCandidateInput input) async {
    try {
      if (input.candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.deletedBy.trim().isEmpty) {
        throw ValidationException('deleted_by is required');
      }

      final response = await apiClient.delete(
        ApiEndpoints.recCandidateByGuid(input.candidateGuid),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to delete candidate';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete candidate: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> deleteCandidateAssessment(DeleteCandidateAssessmentInput input) async {
    try {
      if (input.assessmentGuid.trim().isEmpty) {
        throw ValidationException('assessment_guid is required');
      }
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.deletedBy.trim().isEmpty) {
        throw ValidationException('deleted_by is required');
      }

      final response = await apiClient.delete(
        ApiEndpoints.recCandidateAssessmentByGuid(input.assessmentGuid),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to delete assessment';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete assessment: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateCandidateAssessment(UpdateCandidateAssessmentInput input) async {
    try {
      if (input.assessmentGuid.trim().isEmpty) {
        throw ValidationException('assessment_guid is required');
      }
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.assessmentType.trim().isEmpty) {
        throw ValidationException('assessment_type is required');
      }
      if (input.difficultyLevel.trim().isEmpty) {
        throw ValidationException('difficulty_level is required');
      }
      if (input.durationMinutes <= 0) {
        throw ValidationException('duration_minutes must be greater than 0');
      }
      if (input.completionDueDate.trim().isEmpty) {
        throw ValidationException('completion_due_date is required');
      }
      if (input.statusCode.trim().isEmpty) {
        throw ValidationException('status_code is required');
      }
      if (input.updatedBy.trim().isEmpty) {
        throw ValidationException('updated_by is required');
      }

      final response = await apiClient.put(
        ApiEndpoints.recCandidateAssessmentByGuid(input.assessmentGuid),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update assessment';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update assessment: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Uint8List> getResumeBytes({required String resumeLink}) async {
    try {
      if (resumeLink.trim().isEmpty) {
        throw ValidationException('resume_link is required');
      }

      final endpoint = ApiEndpoints.resolveRecResumePath(resumeLink);

      final response = await apiClient.dio.get<dynamic>(endpoint, options: Options(responseType: ResponseType.bytes));

      final data = response.data;
      if (data == null) return Uint8List(0);
      if (data is Uint8List) return data;
      if (data is List<int>) return Uint8List.fromList(data);
      return Uint8List(0);
    } on DioException catch (e) {
      final message = e.response?.statusMessage ?? e.message ?? 'Failed to fetch resume';
      throw UnknownException(message, statusCode: e.response?.statusCode, originalError: e);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch resume: ${e.toString()}', originalError: e);
    }
  }
}
