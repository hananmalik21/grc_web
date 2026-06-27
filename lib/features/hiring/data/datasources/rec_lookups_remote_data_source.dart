import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/data/dto/rec_lookup_dto.dart';

abstract class RecLookupsRemoteDataSource {
  Future<RecLookupTypesResponseDto> getLookupTypes({required int enterpriseId, int page, int pageSize});

  Future<RecLookupValuesResponseDto> getLookupValues({
    required int enterpriseId,
    required String lookupTypeCode,
    int page,
    int pageSize,
  });
}

class RecLookupsRemoteDataSourceImpl implements RecLookupsRemoteDataSource {
  const RecLookupsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<RecLookupTypesResponseDto> getLookupTypes({required int enterpriseId, int page = 1, int pageSize = 10}) async {
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

      final response = await apiClient.get(
        ApiEndpoints.recLookupTypes,
        queryParameters: {
          'enterprise_id': enterpriseId.toString(),
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch lookup types';
        throw ServerException(message, statusCode: 400);
      }

      return RecLookupTypesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch recruitment lookup types: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<RecLookupValuesResponseDto> getLookupValues({
    required int enterpriseId,
    required String lookupTypeCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }
      final trimmedType = lookupTypeCode.trim();
      if (trimmedType.isEmpty) {
        throw ValidationException('lookup_type must not be empty');
      }
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }
      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final response = await apiClient.get(
        ApiEndpoints.recLookupValues,
        queryParameters: {
          'enterprise_id': enterpriseId.toString(),
          'page': page.toString(),
          'page_size': pageSize.toString(),
          'lookup_type': trimmedType,
        },
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch lookup values';
        throw ServerException(message, statusCode: 400);
      }

      return RecLookupValuesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch recruitment lookup values: ${e.toString()}', originalError: e);
    }
  }
}
