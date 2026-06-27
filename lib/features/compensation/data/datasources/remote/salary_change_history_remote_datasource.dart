import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/exceptions.dart';
import '../../dto/adjustments/salary_change_history_dto.dart';

abstract class SalaryChangeHistoryRemoteDataSource {
  Future<SalaryChangeHistoryResponseDto> getSalaryChangeHistory({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  });
}

class SalaryChangeHistoryRemoteDataSourceImpl implements SalaryChangeHistoryRemoteDataSource {
  final ApiClient apiClient;

  SalaryChangeHistoryRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<SalaryChangeHistoryResponseDto> getSalaryChangeHistory({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParameters['search'] = searchQuery;
      }
      if (status != null && status != 'All Status') {
        queryParameters['status'] = status;
      }
      if (department != null && department != 'All Departments') {
        queryParameters['department'] = department;
      }
      if (region != null && region != 'All Regions') {
        queryParameters['region'] = region;
      }

      final response = await apiClient.get('/api/compensation/salary-change-history', queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch salary change history';
        throw ServerException(message, statusCode: 400);
      }

      return SalaryChangeHistoryResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch salary change history: ${e.toString()}', originalError: e);
    }
  }
}
