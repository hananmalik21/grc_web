import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/payroll/data/dto/pay_lookup_value_dto.dart';

abstract class PayLookupsRemoteDataSource {
  Future<PayLookupValuesResponseDto> getLookupValues({
    required int enterpriseId,
    required String typeCode,
    int page,
    int limit,
    String activeFlag,
  });
}

class PayLookupsRemoteDataSourceImpl implements PayLookupsRemoteDataSource {
  const PayLookupsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<PayLookupValuesResponseDto> getLookupValues({
    required int enterpriseId,
    required String typeCode,
    int page = 1,
    int limit = 100,
    String activeFlag = 'Y',
  }) async {
    try {
      if (enterpriseId <= 0) {
        throw ValidationException('enterprise_id must be greater than 0');
      }

      final trimmedType = typeCode.trim();
      if (trimmedType.isEmpty) {
        throw ValidationException('type_code must not be empty');
      }
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }
      if (limit < 1 || limit > 100) {
        throw ValidationException('limit must be between 1 and 100');
      }

      final response = await apiClient.get(
        ApiEndpoints.payLookupValues,
        queryParameters: {
          'enterprise_id': enterpriseId.toString(),
          'type_code': trimmedType,
          'active_flag': activeFlag.trim().toUpperCase(),
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch payroll lookup values';
        throw ServerException(message, statusCode: 400);
      }

      return PayLookupValuesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch payroll lookup values: ${e.toString()}', originalError: e);
    }
  }
}
