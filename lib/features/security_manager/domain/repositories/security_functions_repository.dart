import '../models/security_function.dart';

abstract class SecurityFunctionsRepository {
  Future<SecurityFunctionPage> getSecurityFunctions({required int page, required int pageSize, String? search});
}
