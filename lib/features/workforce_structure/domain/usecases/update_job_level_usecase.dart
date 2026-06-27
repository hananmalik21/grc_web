import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/job_level_repository.dart';

class UpdateJobLevelUseCase {
  final JobLevelRepository repository;

  UpdateJobLevelUseCase(this.repository);

  Future<JobLevel> execute(JobLevel jobLevel, {int? tenantId}) {
    return repository.updateJobLevel(jobLevel, tenantId: tenantId);
  }
}
