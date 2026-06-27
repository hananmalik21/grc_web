import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/domain/repositories/data_roles_repository.dart';

class GetDataRolesUseCase {
  const GetDataRolesUseCase(this._repository);

  final DataRolesRepository _repository;

  Future<DataRolePage> call({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? dataTypeCode,
  }) {
    return _repository.getDataRoles(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      search: search,
      dataTypeCode: dataTypeCode,
    );
  }
}
