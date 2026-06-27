import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/company_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/company.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CompanyOverview>> getCompanies({int? enterpriseId, String? search, int? page, int? pageSize}) async {
    try {
      final dtos = await remoteDataSource.getCompanies(
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: pageSize,
      );
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompanyOverview> createCompany(Map<String, dynamic> companyData) async {
    try {
      final dto = await remoteDataSource.createCompany(companyData);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompanyOverview> updateCompany(int companyId, Map<String, dynamic> companyData) async {
    try {
      final dto = await remoteDataSource.updateCompany(companyId, companyData);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteCompany(int companyId, {bool hard = true}) async {
    try {
      await remoteDataSource.deleteCompany(companyId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
