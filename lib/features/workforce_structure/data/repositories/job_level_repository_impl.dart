import 'package:grc/features/workforce_structure/data/datasources/job_level_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/job_level_repository.dart';

class JobLevelRepositoryImpl implements JobLevelRepository {
  final JobLevelRemoteDataSource remoteDataSource;

  const JobLevelRepositoryImpl({required this.remoteDataSource});

  @override
  Future<JobLevelResponse> getJobLevels({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    return await remoteDataSource.getJobLevels(page: page, pageSize: pageSize, search: search, tenantId: tenantId);
  }

  @override
  Future<JobLevel> createJobLevel(JobLevel jobLevel, {int? tenantId}) async {
    final data = {
      'level_name_en': jobLevel.nameEn,
      'level_code': jobLevel.code,
      'description': jobLevel.description,
      'min_grade_id': jobLevel.minGradeId,
      'max_grade_id': jobLevel.maxGradeId,
      'status': jobLevel.status,
      'last_update_login': 'SYSTEM',
    };
    if (tenantId != null) {
      data['tenant_id'] = tenantId;
    }
    return await remoteDataSource.createJobLevel(data);
  }

  @override
  Future<JobLevel> updateJobLevel(JobLevel jobLevel, {int? tenantId}) async {
    final data = {
      'description': jobLevel.description,
      'min_grade_id': jobLevel.minGradeId,
      'max_grade_id': jobLevel.maxGradeId,
    };
    if (tenantId != null) {
      data['tenant_id'] = tenantId;
    }
    return await remoteDataSource.updateJobLevel(jobLevel.id, data);
  }

  @override
  Future<void> deleteJobLevel(int id, {int? tenantId}) async {
    await remoteDataSource.deleteJobLevel(id, hard: true, tenantId: tenantId);
  }
}
