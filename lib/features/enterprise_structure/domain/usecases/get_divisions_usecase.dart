import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/division.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/division_repository.dart';

/// Use case for getting divisions
class GetDivisionsUseCase {
  final DivisionRepository repository;

  GetDivisionsUseCase({required this.repository});

  /// Executes the use case to get divisions
  ///
  /// Returns a list of [DivisionOverview]
  /// Throws [AppException] if the operation fails
  Future<List<DivisionOverview>> call({int? enterpriseId, String? search, int? page, int? pageSize}) async {
    try {
      return await repository.getDivisions(enterpriseId: enterpriseId, search: search, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get divisions: ${e.toString()}', originalError: e);
    }
  }
}
