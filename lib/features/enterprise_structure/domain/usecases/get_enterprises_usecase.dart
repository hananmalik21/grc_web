import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_repository.dart';

/// Use case for getting enterprises
class GetEnterprisesUseCase {
  final EnterpriseRepository repository;

  GetEnterprisesUseCase({required this.repository});

  /// Executes the use case to get enterprises
  /// 
  /// Returns list of [Enterprise]
  /// Throws [AppException] if the operation fails
  Future<List<Enterprise>> call() async {
    try {
      return await repository.getEnterprises();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get enterprises: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

