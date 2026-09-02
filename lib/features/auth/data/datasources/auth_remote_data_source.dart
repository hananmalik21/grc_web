import 'package:grc/features/auth/data/models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginApiResponse> login({
    required String loginId,
    required String password,
    int? enterpriseId,
  });

  Future<LoginApiResponse> registerTenant({
    required String orgName,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? country,
    String? industry,
  });
}
