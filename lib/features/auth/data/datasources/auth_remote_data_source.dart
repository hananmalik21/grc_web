import 'package:grc/features/auth/data/models/login_response.dart';

abstract class AuthRemoteDataSource {
  Future<LoginApiResponse> login({required String loginId, required String password, required int enterpriseId});
}
