import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/talent_pools_dto.dart';

abstract class TalentPoolsRemoteDataSource {
  Future<TalentPoolsPageDto> getTalentPools({required int enterpriseId, int page = 1, int pageSize = 10});

  Future<Map<String, dynamic>> createTalentPool({
    required int enterpriseId,
    required String poolName,
    required String createdBy,
  });

  Future<Map<String, dynamic>> addCandidateToTalentPools({
    required String candidateGuid,
    required int enterpriseId,
    required List<String> poolGuids,
    required String updatedBy,
  });
}

class TalentPoolsRemoteDataSourceImpl implements TalentPoolsRemoteDataSource {
  const TalentPoolsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<TalentPoolsPageDto> getTalentPools({required int enterpriseId, int page = 1, int pageSize = 10}) async {
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

      final response = await apiClient.get(ApiEndpoints.recTalentPools, queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch talent pools';
        throw ServerException(message, statusCode: 400);
      }

      return TalentPoolsPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch talent pools: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createTalentPool({
    required int enterpriseId,
    required String poolName,
    required String createdBy,
  }) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      if (poolName.trim().isEmpty) {
        throw ValidationException('pool_name is required');
      }

      final response = await apiClient.post(
        ApiEndpoints.recTalentPools,
        body: <String, dynamic>{
          'enterprise_id': enterpriseId,
          'pool_name': poolName.trim(),
          'created_by': createdBy.trim().isEmpty ? 'ADMIN' : createdBy.trim(),
        },
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create talent pool';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create talent pool: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> addCandidateToTalentPools({
    required String candidateGuid,
    required int enterpriseId,
    required List<String> poolGuids,
    required String updatedBy,
  }) async {
    try {
      if (candidateGuid.trim().isEmpty) {
        throw ValidationException('candidate_guid is required');
      }
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      if (poolGuids.isEmpty) {
        throw ValidationException('At least one pool_guid is required');
      }

      final pools = poolGuids.map((guid) => <String, dynamic>{'pool_guid': guid}).toList();
      final response = await apiClient.post(
        ApiEndpoints.recCandidateTalentPools(candidateGuid),
        body: <String, dynamic>{
          'enterprise_id': enterpriseId,
          'pools': pools,
          'updated_by': updatedBy.trim().isEmpty ? 'ADMIN' : updatedBy.trim(),
        },
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to add candidate to talent pools';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to add candidate to talent pools: ${e.toString()}', originalError: e);
    }
  }
}
