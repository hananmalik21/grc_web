import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grc/features/auth/data/models/login_response.dart';

class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  const DioAuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<LoginApiResponse> login({
    required String loginId,
    required String password,
    int? enterpriseId,
  }) async {
    try {
      // First try standard Identity v1 endpoint (/api/v1/identity/login)
      try {
        final body = <String, dynamic>{
          'email': loginId,
          'password': password,
        };
        final response = await _apiClient.post(ApiEndpoints.identityLogin, body: body);
        return LoginApiResponse.fromJson(response);
      } catch (e) {
        // If 404 on identityLogin, gracefully fallback to legacy securityAuthLogin
        if (e is NotFoundException) {
          final legacyBody = <String, dynamic>{
            'login_id': loginId,
            'password': password,
            'enterprise_id': enterpriseId ?? 1,
          };
          final response = await _apiClient.post(ApiEndpoints.securityAuthLogin, body: legacyBody);
          return LoginApiResponse.fromJson(response);
        }
        rethrow;
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Login failed: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<LoginApiResponse> registerTenant({
    required String orgName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? country,
    String? industry,
  }) async {
    try {
      final body = <String, dynamic>{
        'orgName': orgName,
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        if (country != null && country.isNotEmpty) 'country': country,
        if (industry != null && industry.isNotEmpty) 'industry': industry,
      };

      final response = await _apiClient.post(ApiEndpoints.identityRegister, body: body);
      return LoginApiResponse.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Registration failed: ${e.toString()}', originalError: e);
    }
  }
}
