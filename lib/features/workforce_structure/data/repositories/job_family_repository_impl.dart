import 'package:grc/features/workforce_structure/data/datasources/job_family_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/job_family_repository.dart';

class JobFamilyRepositoryImpl implements JobFamilyRepository {
  final JobFamilyRemoteDataSource remoteDataSource;

  const JobFamilyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<JobFamilyResponse> getJobFamilies({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    return await remoteDataSource.getJobFamilies(page: page, pageSize: pageSize, search: search, tenantId: tenantId);
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
    return await remoteDataSource.createJobFamily(
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      status: status,
      tenantId: tenantId,
    );
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
    return await remoteDataSource.updateJobFamily(
      id: id,
      code: code,
      nameEnglish: nameEnglish,
      nameArabic: nameArabic,
      description: description,
      status: status,
      tenantId: tenantId,
    );
  }

  @override
  Future<void> deleteJobFamily({required int id, bool hard = true, int? tenantId}) async {
    return await remoteDataSource.deleteJobFamily(id: id, hard: hard, tenantId: tenantId);
  }
}
