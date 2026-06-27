import 'package:grc/features/developer_tools/domain/models/security_function.dart';
import 'package:grc/features/developer_tools/domain/repositories/functions_repository.dart';

class GetFunctionsUseCase {
  const GetFunctionsUseCase(this._repository);

  final FunctionsRepository _repository;

  Future<SecurityFunctionPage> call({String? search, int page = 1, int pageSize = 10}) =>
      _repository.getFunctions(search: search, page: page, pageSize: pageSize);
}
