import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/components/comp_components_page_dto.dart';

abstract class CompComponentsRemoteDataSource {
  Future<CompComponentsPageDto> getComponents({
    required int tenantId,
    required int page,
    required int pageSize,
    int? salaryStructureId,
    String? search,
    String? category,
    String? calculationMethod,
    String? status,
  });

  Future<void> deleteComponent({required String componentGuid, required int tenantId});
}

class CompComponentsRemoteDataSourceImpl implements CompComponentsRemoteDataSource {
  final ApiClient apiClient;

  CompComponentsRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders() {
    return {'x-user-id': 'admin'};
  }

  @override
  Future<CompComponentsPageDto> getComponents({
    required int tenantId,
    required int page,
    required int pageSize,
    int? salaryStructureId,
    String? search,
    String? category,
    String? calculationMethod,
    String? status,
  }) async {
    try {
      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (salaryStructureId != null) {
        queryParameters['salary_structure_id'] = salaryStructureId.toString();
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (category != null) {
        queryParameters['category'] = category;
      }
      if (calculationMethod != null) {
        queryParameters['calculation'] = calculationMethod;
      }
      if (status != null) {
        queryParameters['status'] = status;
      }

      final response = await apiClient.get(
        ApiEndpoints.compComponents,
        queryParameters: queryParameters,
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch components';
        throw ServerException(message, statusCode: 400);
      }

      return CompComponentsPageDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch components: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteComponent({required String componentGuid, required int tenantId}) async {
    try {
      final endpoint = '${ApiEndpoints.compComponents}/$componentGuid';
      final response = await apiClient.delete(endpoint, body: {'tenant_id': tenantId, 'user': 'admin'});
      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to delete component';
        throw ServerException(message, statusCode: 400);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete component: ${e.toString()}', originalError: e);
    }
  }
}
