import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';

/// Repository interface for enterprise operations
abstract class EnterpriseRepository {
  /// Gets list of all enterprises
  /// 
  /// Throws [AppException] if the operation fails
  Future<List<Enterprise>> getEnterprises();
}

