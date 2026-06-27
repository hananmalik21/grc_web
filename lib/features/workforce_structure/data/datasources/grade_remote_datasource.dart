import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/workforce_structure/data/models/grade_model.dart';
import 'package:grc/features/workforce_structure/data/models/grade_response_model.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/grade_response.dart';

abstract class GradeRemoteDataSource {
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10, String? search, int? tenantId});
  Future<Grade> createGrade(Map<String, dynamic> data);
  Future<Grade> updateGrade(int gradeId, Map<String, dynamic> data);
  Future<void> deleteGrade(int gradeId, {int? tenantId});
}

class GradeRemoteDataSourceImpl implements GradeRemoteDataSource {
  final ApiClient apiClient;

  const GradeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    final queryParams = {'page': page.toString(), 'page_size': pageSize.toString()};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (tenantId != null) {
      queryParams['tenant_id'] = tenantId.toString();
    }

    final response = await apiClient.get(ApiEndpoints.grades, queryParameters: queryParams);

    return GradeResponseModel.fromJson(response).toEntity();
  }

  @override
  Future<Grade> createGrade(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.grades, body: data);

    return GradeModel.fromJson(response['data'] as Map<String, dynamic>).toEntity();
  }

  @override
  Future<Grade> updateGrade(int gradeId, Map<String, dynamic> data) async {
    final response = await apiClient.put('${ApiEndpoints.grades}/$gradeId', body: data);

    return GradeModel.fromJson(response['data'] as Map<String, dynamic>).toEntity();
  }

  @override
  Future<void> deleteGrade(int gradeId, {int? tenantId}) async {
    final queryParams = <String, String>{'hard': 'true'};
    if (tenantId != null) queryParams['tenant_id'] = tenantId.toString();
    await apiClient.delete('${ApiEndpoints.grades}/$gradeId', queryParameters: queryParams);
  }
}
