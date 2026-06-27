import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:grc/features/auth/data/models/login_response.dart';

class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  const DioAuthRemoteDataSource({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<LoginApiResponse> login({required String loginId, required String password, required int enterpriseId}) async {
    try {
      final body = <String, dynamic>{'login_id': loginId, 'password': password, 'enterprise_id': enterpriseId};
      final response = await _apiClient.post(ApiEndpoints.securityAuthLogin, body: body);
      return LoginApiResponse.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Login failed: ${e.toString()}', originalError: e);
    }
  }
}
