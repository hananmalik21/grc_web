import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/paginated_projects_dto.dart';

abstract class ProjectRemoteDataSource {
  Future<PaginatedProjectsDto> getProjects({
    required int enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  });
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedProjectsDto> getProjects({
    required int enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      final response = await apiClient.get(ApiEndpoints.tmProjects, queryParameters: queryParameters);

      return PaginatedProjectsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch projects: ${e.toString()}', originalError: e);
    }
  }
}
