import 'package:grc/features/workforce_structure/domain/models/job_family_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/job_family_repository.dart';

class GetJobFamiliesUseCase {
  final JobFamilyRepository repository;

  const GetJobFamiliesUseCase({required this.repository});

  Future<JobFamilyResponse> call({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    return await repository.getJobFamilies(page: page, pageSize: pageSize, search: search, tenantId: tenantId);
  }
}
