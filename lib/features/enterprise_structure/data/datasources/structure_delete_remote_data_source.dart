import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';

/// Remote data source for structure delete operations
abstract class StructureDeleteRemoteDataSource {
  Future<Map<String, dynamic>> deleteStructure({
    required String structureId,
    bool? hard,
    bool? autoFallback,
  });
}

class StructureDeleteRemoteDataSourceImpl
    implements StructureDeleteRemoteDataSource {
  final ApiClient apiClient;

  StructureDeleteRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> deleteStructure({
    required String structureId,
    bool? hard,
    bool? autoFallback,
  }) async {
    try {
      // Build query parameters - only pass one at a time
      final queryParameters = <String, String>{};
      
      if (hard != null) {
        queryParameters['hard'] = hard.toString();
      } else if (autoFallback != null) {
        queryParameters['autofallback'] = autoFallback.toString();
      }

      final response = await apiClient.delete(
        ApiEndpoints.hrOrgStructuresDelete(structureId),
        queryParameters: queryParameters,
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete structure: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

