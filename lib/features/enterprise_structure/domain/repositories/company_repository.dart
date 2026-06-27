import 'package:grc/features/enterprise_structure/domain/models/company.dart';

abstract class CompanyRepository {
  Future<List<CompanyOverview>> getCompanies({int? enterpriseId, String? search, int? page, int? pageSize});
  Future<CompanyOverview> createCompany(Map<String, dynamic> companyData);
  Future<CompanyOverview> updateCompany(int companyId, Map<String, dynamic> companyData);
  Future<void> deleteCompany(int companyId, {bool hard = true});
}
