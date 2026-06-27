import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/company_dto.dart';

abstract class CompanyRemoteDataSource {
  Future<List<CompanyDto>> getCompanies({int? enterpriseId, String? search, int? page, int? pageSize});
  Future<CompanyDto> createCompany(Map<String, dynamic> companyData);
  Future<CompanyDto> updateCompany(int companyId, Map<String, dynamic> companyData);
  Future<void> deleteCompany(int companyId, {bool hard = true});
}

class CompanyRemoteDataSourceImpl implements CompanyRemoteDataSource {
  final ApiClient apiClient;

  CompanyRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CompanyDto>> getCompanies({int? enterpriseId, String? search, int? page, int? pageSize}) async {
    try {
      final queryParameters = <String, String>{};
      if (enterpriseId != null) {
        queryParameters['enterprise_id'] = enterpriseId.toString();
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }
      if (page != null) {
        queryParameters['page'] = page.toString();
      }
      if (pageSize != null) {
        queryParameters['page_size'] = pageSize.toString();
      }

      final response = await apiClient.get(
        ApiEndpoints.companies,
        queryParameters: queryParameters.isNotEmpty ? queryParameters : null,
      );

      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('companies') && response['companies'] is List) {
        data = response['companies'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data.whereType<Map<String, dynamic>>().map((json) => CompanyDto.fromJson(json)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch companies: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompanyDto> createCompany(Map<String, dynamic> companyData) async {
    try {
      final response = await apiClient.post(ApiEndpoints.companies, body: companyData);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return CompanyDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create company: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<CompanyDto> updateCompany(int companyId, Map<String, dynamic> companyData) async {
    try {
      final response = await apiClient.put('${ApiEndpoints.companies}/$companyId', body: companyData);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return CompanyDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update company: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteCompany(int companyId, {bool hard = true}) async {
    try {
      await apiClient.delete('${ApiEndpoints.companies}/$companyId', queryParameters: {'hard': hard.toString()});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete company: ${e.toString()}', originalError: e);
    }
  }
}
