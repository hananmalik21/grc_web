import 'package:grc/features/security_manager/domain/repositories/data_roles_repository.dart';

class CreateDataRoleUseCase {
  const CreateDataRoleUseCase(this._repository);

  final DataRolesRepository _repository;

  Future<void> call({required Map<String, dynamic> body}) {
    return _repository.createDataRole(body: body);
  }
}
