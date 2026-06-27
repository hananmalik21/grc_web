import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';

abstract class ElementEntriesRemoteDataSource {
  Future<void> createElementEntry({required Map<String, dynamic> body});
}

class ElementEntriesRemoteDataSourceImpl implements ElementEntriesRemoteDataSource {
  const ElementEntriesRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<void> createElementEntry({required Map<String, dynamic> body}) async {
    try {
      final response = await apiClient.post(ApiEndpoints.payElementEntries, body: body);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to create element entry';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create element entry: ${e.toString()}', originalError: e);
    }
  }
}
