import 'package:grc_web/features/auth/data/models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto> getCurrentUser();
}

