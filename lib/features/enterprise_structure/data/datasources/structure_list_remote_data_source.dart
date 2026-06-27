import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/structure_list_dto.dart';

abstract class StructureListRemoteDataSource {
  Future<PaginatedStructureListDto> getStructures({required int enterpriseId, int page = 1, int pageSize = 10});
}

class StructureListRemoteDataSourceImpl implements StructureListRemoteDataSource {
  final ApiClient apiClient;

  StructureListRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedStructureListDto> getStructures({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    try {
      final queryParams = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      final response = await apiClient.get(ApiEndpoints.hrOrgStructures, queryParameters: queryParams);

      return PaginatedStructureListDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch structures: ${e.toString()}', originalError: e);
    }
  }
}
