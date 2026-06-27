import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/company_repository.dart';

/// Use case for deleting a company
class DeleteCompanyUseCase {
  final CompanyRepository repository;

  DeleteCompanyUseCase({required this.repository});

  /// Executes the use case to delete a company
  ///
  /// [companyId] - The ID of the company to delete
  /// [hard] - If true, permanently deletes the company. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> call(int companyId, {bool hard = true}) async {
    try {
      return await repository.deleteCompany(companyId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete company: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

