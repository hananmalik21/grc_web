import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family_response.dart';

abstract class JobFamilyRepository {
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
