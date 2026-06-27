import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/company.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/company_repository.dart';

/// Use case for getting companies
class GetCompaniesUseCase {
  final CompanyRepository repository;

  GetCompaniesUseCase({required this.repository});

  /// Executes the use case to get companies
  ///
  /// [search] - Optional search query to filter companies
  /// [page] - Optional page number for pagination
  /// [pageSize] - Optional page size for pagination
  /// Returns list of [CompanyOverview]
  /// Throws [AppException] if the operation fails
  Future<List<CompanyOverview>> call({int? enterpriseId, String? search, int? page, int? pageSize}) async {
    try {
      return await repository.getCompanies(enterpriseId: enterpriseId, search: search, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get companies: ${e.toString()}', originalError: e);
    }
  }
}
