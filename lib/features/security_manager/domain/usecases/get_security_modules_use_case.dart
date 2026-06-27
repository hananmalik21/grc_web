import '../models/security_module.dart';
import '../repositories/security_modules_repository.dart';

class GetSecurityModulesUseCase {
  const GetSecurityModulesUseCase(this._repository);

  final SecurityModulesRepository _repository;

  Future<SecurityModulePage> call({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String activeFlag = 'Y',
  }) {
    return _repository.getSecurityModules(
      enterpriseId: enterpriseId,
      page: page,
      pageSize: pageSize,
      activeFlag: activeFlag,
    );
  }
}
