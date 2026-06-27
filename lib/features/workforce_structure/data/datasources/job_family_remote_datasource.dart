import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/workforce_structure/data/models/job_family_model.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family_response.dart';

abstract class JobFamilyRemoteDataSource {
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10, String? search, int? tenantId});
  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    String nameArabic = '',
    required String description,
    String status = 'ACTIVE',
    int? tenantId,
  });
  Future<JobFamily> updateJobFamily({
    required int id,
    required String code,
    required String nameEnglish,
    String nameArabic = '',
    required String description,
    String status = 'ACTIVE',
    int? tenantId,
  });
  Future<void> deleteJobFamily({required int id, bool hard = true, int? tenantId});
}

class JobFamilyRemoteDataSourceImpl implements JobFamilyRemoteDataSource {
  final ApiClient apiClient;

  const JobFamilyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    final queryParams = {'page': page.toString(), 'page_size': pageSize.toString()};

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (tenantId != null) {
      queryParams['tenant_id'] = tenantId.toString();
    }

    final response = await apiClient.get(ApiEndpoints.jobFamilies, queryParameters: queryParams);

    return JobFamilyResponse.fromJson(response);
  }

  @override
  Future<JobFamily> createJobFamily({
    required String code,
    required String nameEnglish,
    String nameArabic = '',
    required String description,
    String status = 'ACTIVE',
    int? tenantId,
  }) async {
    final body = {
      'job_family_code': code,
      'job_family_name_en': nameEnglish,
      'job_family_name_ar': nameArabic,
      'description': description,
      'status': status,
    };
    if (tenantId != null) body['tenant_id'] = tenantId.toString();
    final response = await apiClient.post(ApiEndpoints.jobFamilies, body: body);
    final model = JobFamilyModel.fromJson(response['data']);
    return model.toEntity();
  }

  @override
  Future<JobFamily> updateJobFamily({
    required int id,
    required String code,
    required String nameEnglish,
    String nameArabic = '',
    required String description,
    String status = 'ACTIVE',
    int? tenantId,
  }) async {
    final body = {
      'job_family_code': code,
      'job_family_name_en': nameEnglish,
      'job_family_name_ar': nameArabic,
      'description': description,
      'status': status,
    };
    if (tenantId != null) body['tenant_id'] = tenantId.toString();
    final response = await apiClient.put('${ApiEndpoints.jobFamilies}/$id', body: body);
    final model = JobFamilyModel.fromJson(response['data']);
    return model.toEntity();
  }

  @override
  Future<void> deleteJobFamily({required int id, bool hard = true, int? tenantId}) async {
    final queryParams = <String, String>{'hard': hard.toString()};
    if (tenantId != null) queryParams['tenant_id'] = tenantId.toString();
    await apiClient.delete('${ApiEndpoints.jobFamilies}/$id', queryParameters: queryParams);
  }
}
