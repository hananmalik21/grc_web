import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/job_offers_dto.dart';
import 'package:grc/features/hiring/domain/models/job_offers/create_job_offer_input.dart';
import 'package:grc/features/hiring/domain/models/job_offers/job_offer_status_action.dart';

abstract class JobOffersRemoteDataSource {
  Future<JobOffersPageDto> getJobOffers({required int enterpriseId, int page = 1, int limit = 10, String? status});

  Future<Map<String, dynamic>> performJobOfferStatusAction(PerformJobOfferStatusActionInput input);

  Future<Map<String, dynamic>> createJobOffer(CreateJobOfferInput input);
}

class JobOffersRemoteDataSourceImpl implements JobOffersRemoteDataSource {
  const JobOffersRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<JobOffersPageDto> getJobOffers({
    required int enterpriseId,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
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

      final trimmedStatus = status?.trim();
      if (trimmedStatus != null && trimmedStatus.isNotEmpty) {
        queryParameters['status'] = trimmedStatus.toUpperCase();
      }

      final response = await apiClient.get(ApiEndpoints.recJobOffers, queryParameters: queryParameters);

      _ensureSuccessResponse(response, 'Failed to fetch job offers');

      return JobOffersPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch job offers: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> performJobOfferStatusAction(PerformJobOfferStatusActionInput input) async {
    try {
      final offerGuid = input.offerGuid.trim();
      if (offerGuid.isEmpty) {
        throw ValidationException('offer_guid is required');
      }

      final endpoint = switch (input.action) {
        JobOfferStatusAction.approve => ApiEndpoints.recJobOfferApprove(offerGuid),
        JobOfferStatusAction.extend => ApiEndpoints.recJobOfferExtend(offerGuid),
        JobOfferStatusAction.withdraw => ApiEndpoints.recJobOfferWithdraw(offerGuid),
      };

      final response = await apiClient.post(endpoint, body: input.toJson());

      _ensureSuccessResponse(response, _failureMessageForAction(input.action));

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('${_failureMessageForAction(input.action)}: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createJobOffer(CreateJobOfferInput input) async {
    try {
      if (input.enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (input.applicationGuid.trim().isEmpty) {
        throw ValidationException('application_guid is required');
      }
      if (input.candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (input.jobTitle.trim().isEmpty) {
        throw ValidationException('job_title is required');
      }
      if (input.components.isEmpty) {
        throw ValidationException('At least one compensation component is required');
      }

      final response = await apiClient.post(ApiEndpoints.recJobOffers, body: input.toJson());

      _ensureSuccessResponse(response, 'Failed to create job offer');

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create job offer: ${e.toString()}', originalError: e);
    }
  }

  String _failureMessageForAction(JobOfferStatusAction action) {
    return switch (action) {
      JobOfferStatusAction.approve => 'Failed to approve job offer',
      JobOfferStatusAction.extend => 'Failed to extend job offer',
      JobOfferStatusAction.withdraw => 'Failed to withdraw job offer',
    };
  }

  void _ensureSuccessResponse(Map<String, dynamic> response, String fallbackMessage) {
    final success = response['success'] as bool?;
    final status = (response['status'] as String?)?.toLowerCase();

    if (success == false || status == 'error' || status == 'failed') {
      final message = response['message'] as String? ?? fallbackMessage;
      throw ServerException(message, statusCode: 400);
    }
  }
}
