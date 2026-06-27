import '../models/security_module.dart';

abstract class SecurityModulesRepository {
  Future<SecurityModulePage> getSecurityModules({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String activeFlag,
  });
}
