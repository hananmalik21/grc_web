import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/job_posting_dto.dart';
import 'package:grc/features/hiring/domain/models/job_postings/create_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/activate_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/pause_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/update_job_posting_input.dart';

abstract class JobPostingsRemoteDataSource {
  Future<Map<String, dynamic>> createJobPosting(CreateJobPostingInput input);

  Future<JobPostingsListDto> getJobPostingsByRequisition({required int enterpriseId, required String requisitionGuid});

  Future<Map<String, dynamic>> pauseJobPosting(PauseJobPostingInput input);

  Future<Map<String, dynamic>> activateJobPosting(ActivateJobPostingInput input);

  Future<Map<String, dynamic>> updateJobPosting(UpdateJobPostingInput input);
}

class JobPostingsRemoteDataSourceImpl implements JobPostingsRemoteDataSource {
  const JobPostingsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<Map<String, dynamic>> createJobPosting(CreateJobPostingInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }
      if (input.postingTitle.trim().isEmpty) {
        throw ValidationException('posting_title is required');
      }
      if (input.startDate.trim().isEmpty) {
        throw ValidationException('start_date is required');
      }

      final response = await apiClient.post(ApiEndpoints.recJobPostings, body: input.toJson());

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create job posting';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create job posting: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<JobPostingsListDto> getJobPostingsByRequisition({
    required int enterpriseId,
    required String requisitionGuid,
  }) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (requisitionGuid.trim().isEmpty) {
        throw ValidationException('requisition_guid is required');
      }

      final response = await apiClient.get(
        ApiEndpoints.recJobPostings,
        queryParameters: {'enterprise_id': enterpriseId.toString(), 'requisition_guid': requisitionGuid.trim()},
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch job postings';
        throw ServerException(message, statusCode: 400);
      }

      return JobPostingsListDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch job postings: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> pauseJobPosting(PauseJobPostingInput input) async {
    try {
      if (input.postingGuid.trim().isEmpty) {
        throw ValidationException('posting_guid is required');
      }
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.pausedBy.trim().isEmpty) {
        throw ValidationException('paused_by is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recJobPostingPause(input.postingGuid.trim()),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to pause job posting';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to pause job posting: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> activateJobPosting(ActivateJobPostingInput input) async {
    try {
      if (input.postingGuid.trim().isEmpty) {
        throw ValidationException('posting_guid is required');
      }
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.activatedBy.trim().isEmpty) {
        throw ValidationException('activated_by is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recJobPostingActivate(input.postingGuid.trim()),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to activate job posting';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to activate job posting: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateJobPosting(UpdateJobPostingInput input) async {
    try {
      if (input.postingGuid.trim().isEmpty) {
        throw ValidationException('posting_guid is required');
      }
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.postingTitle.trim().isEmpty) {
        throw ValidationException('posting_title is required');
      }
      if (input.startDate.trim().isEmpty) {
        throw ValidationException('start_date is required');
      }
      if (input.lastUpdatedBy.trim().isEmpty) {
        throw ValidationException('last_updated_by is required');
      }

      final response = await apiClient.put(
        ApiEndpoints.recJobPostingByGuid(input.postingGuid.trim()),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to update job posting';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update job posting: ${e.toString()}', originalError: e);
    }
  }
}
