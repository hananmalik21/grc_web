import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/features/security_manager/domain/repositories/job_roles_repository.dart';

class GetJobRolesUseCase {
  const GetJobRolesUseCase(this._repository);

  final JobRolesRepository _repository;

  Future<JobRolePage> call({required int enterpriseId, required int page, required int pageSize, String? search}) {
    return _repository.getJobRoles(enterpriseId: enterpriseId, page: page, pageSize: pageSize, search: search);
  }
}
