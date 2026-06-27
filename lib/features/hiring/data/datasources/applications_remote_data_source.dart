import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/hiring/data/dto/application_detail_dto.dart';
import 'package:grc/features/hiring/data/dto/applications_dto.dart';
import 'package:grc/features/hiring/domain/models/applications/add_application_note_input.dart';
import 'package:grc/features/hiring/domain/models/applications/change_application_stage_input.dart';
import 'package:grc/features/hiring/domain/models/applications/reject_application_input.dart';

abstract class ApplicationsRemoteDataSource {
  Future<ApplicationsPageDto> getApplications({required int enterpriseId, int page = 1, int limit = 10});

  Future<ApplicationDetailDto> getApplicationByGuid({required String applicationGuid, required int enterpriseId});

  Future<Map<String, dynamic>> changeApplicationStage(ChangeApplicationStageInput input);

  Future<Map<String, dynamic>> addApplicationNote(AddApplicationNoteInput input);

  Future<Map<String, dynamic>> rejectApplication(RejectApplicationInput input);
}

class ApplicationsRemoteDataSourceImpl implements ApplicationsRemoteDataSource {
  const ApplicationsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<ApplicationsPageDto> getApplications({required int enterpriseId, int page = 1, int limit = 10}) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (limit < 1 || limit > 100) {
        throw ValidationException('limit must be between 1 and 100');
      }

      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final response = await apiClient.get(ApiEndpoints.recApplications, queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch applications';
        throw ServerException(message, statusCode: 400);
      }

      return ApplicationsPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch applications: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ApplicationDetailDto> getApplicationByGuid({
    required String applicationGuid,
    required int enterpriseId,
  }) async {
    try {
      if (applicationGuid.trim().isEmpty) {
        throw ValidationException('application_guid is required');
      }

      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final response = await apiClient.get(
        ApiEndpoints.recApplicationByGuid(applicationGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch application';
        throw ServerException(message, statusCode: 400);
      }

      return ApplicationDetailDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch application: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> changeApplicationStage(ChangeApplicationStageInput input) async {
    try {
      if (input.applicationGuid.trim().isEmpty) {
        throw ValidationException('application_guid is required');
      }

      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (input.currentStageCode.trim().isEmpty) {
        throw ValidationException('current_stage_code is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recApplicationChangeStage(input.applicationGuid),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to change application stage';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to change application stage: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> addApplicationNote(AddApplicationNoteInput input) async {
    try {
      if (input.applicationGuid.trim().isEmpty) {
        throw ValidationException('application_guid is required');
      }

      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (input.noteTypeCode.trim().isEmpty) {
        throw ValidationException('note_type_code is required');
      }

      if (input.noteText.trim().isEmpty) {
        throw ValidationException('note_text is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recApplicationNotes(input.applicationGuid),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to add application note';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to add application note: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectApplication(RejectApplicationInput input) async {
    try {
      if (input.applicationGuid.trim().isEmpty) {
        throw ValidationException('application_guid is required');
      }

      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (input.rejectionReasonCode.trim().isEmpty) {
        throw ValidationException('rejection_reason_code is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recApplicationReject(input.applicationGuid),
        body: input.toJson(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to reject application';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject application: ${e.toString()}', originalError: e);
    }
  }
}
