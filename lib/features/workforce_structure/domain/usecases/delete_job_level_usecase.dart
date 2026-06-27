import 'package:grc/features/workforce_structure/domain/repositories/job_level_repository.dart';

class DeleteJobLevelUseCase {
  final JobLevelRepository repository;

  DeleteJobLevelUseCase(this.repository);

  Future<void> execute(int id, {int? tenantId}) {
    return repository.deleteJobLevel(id, tenantId: tenantId);
  }
}
