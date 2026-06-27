import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level_response.dart';

abstract class JobLevelRepository {
  Future<JobLevelResponse> getJobLevels({int page = 1, int pageSize = 10, String? search, int? tenantId});
  Future<JobLevel> createJobLevel(JobLevel jobLevel, {int? tenantId});
  Future<JobLevel> updateJobLevel(JobLevel jobLevel, {int? tenantId});
  Future<void> deleteJobLevel(int id, {int? tenantId});
}
