import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/interviews_dto.dart';

import 'package:grc/features/hiring/domain/models/submit_interview_feedback_input.dart';
import 'package:grc/features/hiring/domain/models/update_interview_input.dart';

abstract class InterviewsRemoteDataSource {
  Future<InterviewsPageDto> getInterviews({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> submitInterviewFeedback(SubmitInterviewFeedbackInput input);

  Future<Map<String, dynamic>> updateInterview(UpdateInterviewInput input);
}

class InterviewsRemoteDataSourceImpl implements InterviewsRemoteDataSource {
  const InterviewsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<InterviewsPageDto> getInterviews({required int enterpriseId, int page = 1, int pageSize = 10}) async {
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

      final response = await apiClient.get(ApiEndpoints.recCandidatesInterviews, queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch interviews';
        throw ServerException(message, statusCode: 400);
      }

      return InterviewsPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch interviews: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> submitInterviewFeedback(SubmitInterviewFeedbackInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (input.interviewGuid.trim().isEmpty) {
        throw ValidationException('interview_guid is required');
      }

      if (input.overallRating < 1 || input.overallRating > 5) {
        throw ValidationException('overall_rating must be between 1 and 5');
      }

      if (input.recommendation == null || input.recommendation!.trim().isEmpty) {
        throw ValidationException('recommendation is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recCandidateInterviewFeedback(input.interviewGuid.trim()),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to submit interview feedback';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to submit interview feedback: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateInterview(UpdateInterviewInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (input.interviewGuid.trim().isEmpty) {
        throw ValidationException('interview_guid is required');
      }

      if (input.updatedBy.trim().isEmpty) {
        throw ValidationException('updated_by is required');
      }

      final response = await apiClient.put(
        ApiEndpoints.recCandidateInterviewByGuid(input.interviewGuid.trim()),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update interview';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update interview: ${e.toString()}', originalError: e);
    }
  }
}
