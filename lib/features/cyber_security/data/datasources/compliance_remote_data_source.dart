import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/cyber_security/data/models/compliance_dto.dart';

abstract class ComplianceRemoteDataSource {
  Future<List<ComplianceFrameworkDto>> getFrameworks();
  Future<List<Map<String, dynamic>>> getFrameworkControls(String frameworkId);
  Future<List<ComplianceAssessmentDto>> getAssessments({
    int page = 1,
    int pageSize = 100,
  });
  Future<Map<String, dynamic>> getAssessment(String assessmentId);
  Future<List<Map<String, dynamic>>> getAssessmentControls(String assessmentId);
  Future<Map<String, dynamic>> createAssessment({
    required String frameworkVersionId,
    required String name,
  });
  Future<Map<String, dynamic>> updateAssessmentControl(
    String assessmentId,
    String controlId,
    Map<String, dynamic> body,
  );
}

class DioComplianceRemoteDataSource implements ComplianceRemoteDataSource {
  const DioComplianceRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<ComplianceFrameworkDto>> getFrameworks() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.complianceFrameworks);
      return _listFrom(
        response['data'],
      ).map(ComplianceFrameworkDto.fromJson).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load compliance frameworks: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<ComplianceAssessmentDto>> getAssessments({
    int page = 1,
    int pageSize = 100,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.complianceAssessments,
        queryParameters: {'page': '$page', 'pageSize': '$pageSize'},
      );
      return _listFrom(
        response['data'],
      ).map(ComplianceAssessmentDto.fromJson).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to load compliance assessments: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFrameworkControls(
    String frameworkId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.complianceFrameworkControls(frameworkId),
      queryParameters: {'page': '1', 'pageSize': '100'},
    );
    return _flatten(response['data']);
  }

  @override
  Future<Map<String, dynamic>> getAssessment(String assessmentId) async {
    final response = await _apiClient.get(
      ApiEndpoints.complianceAssessment(assessmentId),
    );
    return response['data'] as Map<String, dynamic>? ?? const {};
  }

  @override
  Future<List<Map<String, dynamic>>> getAssessmentControls(
    String assessmentId,
  ) async {
    final response = await _apiClient.get(
      ApiEndpoints.complianceAssessmentControls(assessmentId),
      queryParameters: {'page': '1', 'pageSize': '100'},
    );
    return _flatten(response['data']);
  }

  @override
  Future<Map<String, dynamic>> createAssessment({
    required String frameworkVersionId,
    required String name,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.complianceAssessments,
      body: {'frameworkVersionId': frameworkVersionId, 'name': name},
    );
    return response['data'] as Map<String, dynamic>? ?? const {};
  }

  @override
  Future<Map<String, dynamic>> updateAssessmentControl(
    String assessmentId,
    String controlId,
    Map<String, dynamic> body,
  ) async {
    final response = await _apiClient.patch(
      ApiEndpoints.complianceAssessmentControl(assessmentId, controlId),
      body: body,
    );
    return response['data'] as Map<String, dynamic>? ?? const {};
  }

  List<Map<String, dynamic>> _listFrom(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<Map<String, dynamic>>().toList();
  }

  List<Map<String, dynamic>> _flatten(dynamic value) {
    if (value is! List) return const [];
    return value.expand<Map<String, dynamic>>((item) {
      if (item is Map<String, dynamic> && item['controls'] is List) {
        return (item['controls'] as List).whereType<Map<String, dynamic>>();
      }
      return item is Map<String, dynamic> ? [item] : const [];
    }).toList();
  }
}
