import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/structure_level_dto.dart';

/// Remote data source for structure levels
/// Handles all API calls related to structure levels
abstract class StructureLevelRemoteDataSource {
  Future<List<StructureLevelDto>> getStructureLevels();
}

class StructureLevelRemoteDataSourceImpl implements StructureLevelRemoteDataSource {
  final ApiClient apiClient;

  StructureLevelRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<StructureLevelDto>> getStructureLevels() async {
    try {
      final response = await apiClient.get(ApiEndpoints.structureLevels);

      // Handle different response formats
      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('structureLevels') && response['structureLevels'] is List) {
        data = response['structureLevels'] as List<dynamic>;
      } else if (response.containsKey('levels') && response['levels'] is List) {
        data = response['levels'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data.whereType<Map<String, dynamic>>().map((json) => StructureLevelDto.fromJson(json)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch structure levels: ${e.toString()}', originalError: e);
    }
  }
}
