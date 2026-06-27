import '../models/function_role.dart';
import '../repositories/function_roles_repository.dart';

class GetFunctionRolesUseCase {
  const GetFunctionRolesUseCase(this._repository);

  final FunctionRolesRepository _repository;

  Future<FunctionRolePage> call({
    required int enterpriseId,
    String? search,
    int? moduleId,
    int page = 1,
    int pageSize = 10,
  }) => _repository.getFunctionRoles(
    enterpriseId: enterpriseId,
    search: search,
    moduleId: moduleId,
    page: page,
    pageSize: pageSize,
  );
}
