import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/workforce_structure/data/models/job_level_model.dart';
import 'package:grc/features/workforce_structure/data/models/job_level_response_model.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level_response.dart';

abstract class JobLevelRemoteDataSource {
  Future<JobLevelResponse> getJobLevels({int page = 1, int pageSize = 10, String? search, int? tenantId});
  Future<JobLevel> createJobLevel(Map<String, dynamic> data);
  Future<JobLevel> updateJobLevel(int id, Map<String, dynamic> data);
  Future<void> deleteJobLevel(int id, {bool hard = true, int? tenantId});
}

class JobLevelRemoteDataSourceImpl implements JobLevelRemoteDataSource {
  final ApiClient apiClient;

  const JobLevelRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobLevelResponse> getJobLevels({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    final queryParams = {'page': page.toString(), 'page_size': pageSize.toString()};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (tenantId != null) {
      queryParams['tenant_id'] = tenantId.toString();
    }

    final response = await apiClient.get(ApiEndpoints.jobLevels, queryParameters: queryParams);

    return JobLevelResponseModel.fromJson(response);
  }

  @override
  Future<JobLevel> createJobLevel(Map<String, dynamic> data) async {
    final response = await apiClient.post(ApiEndpoints.jobLevels, body: data);

    return JobLevelModel.fromJson(response['data'] as Map<String, dynamic>).toEntity();
  }

  @override
  Future<JobLevel> updateJobLevel(int id, Map<String, dynamic> data) async {
    final response = await apiClient.put('${ApiEndpoints.jobLevels}/$id', body: data);

    return JobLevelModel.fromJson(response['data'] as Map<String, dynamic>).toEntity();
  }

  @override
  Future<void> deleteJobLevel(int id, {bool hard = true, int? tenantId}) async {
    final queryParams = <String, String>{'hard': hard.toString()};
    if (tenantId != null) queryParams['tenant_id'] = tenantId.toString();
    await apiClient.delete('${ApiEndpoints.jobLevels}/$id', queryParameters: queryParams);
  }
}
