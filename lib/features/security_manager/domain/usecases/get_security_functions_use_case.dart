import '../models/security_function.dart';
import '../repositories/security_functions_repository.dart';

class GetSecurityFunctionsUseCase {
  const GetSecurityFunctionsUseCase(this._repository);

  final SecurityFunctionsRepository _repository;

  Future<SecurityFunctionPage> call({required int page, required int pageSize, String? search}) =>
      _repository.getSecurityFunctions(page: page, pageSize: pageSize, search: search);
}
