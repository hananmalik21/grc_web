import 'package:grc/features/developer_tools/data/datasources/function_management_remote_data_source.dart';
import 'package:grc/features/developer_tools/domain/models/security_function.dart';
import 'package:grc/features/developer_tools/domain/repositories/functions_repository.dart';

class FunctionsRepositoryImpl implements FunctionsRepository {
  const FunctionsRepositoryImpl(this._dataSource);

  final FunctionManagementRemoteDataSource _dataSource;

  @override
  Future<SecurityFunctionPage> getFunctions({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    final result = await _dataSource.getFunctions(
      search: search,
      page: page,
      pageSize: pageSize,
    );

    return SecurityFunctionPage(
      functions: result.items,
      page: result.currentPage,
      pageSize: result.pageSize,
      total: result.totalItems,
      totalPages: result.totalPages,
      hasNext: result.hasNext,
      hasPrevious: result.hasPrevious,
    );
  }
}
