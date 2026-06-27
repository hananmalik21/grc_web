import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/job_level_repository.dart';

class CreateJobLevelUseCase {
  final JobLevelRepository repository;

  CreateJobLevelUseCase(this.repository);

  Future<JobLevel> execute(JobLevel jobLevel, {int? tenantId}) {
    return repository.createJobLevel(jobLevel, tenantId: tenantId);
  }
}
