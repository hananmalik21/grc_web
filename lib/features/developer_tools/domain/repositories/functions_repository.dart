import 'package:grc/features/developer_tools/domain/models/security_function.dart';

abstract class FunctionsRepository {
  Future<SecurityFunctionPage> getFunctions({
    String? search,
    int page = 1,
    int pageSize = 10,
  });
}
