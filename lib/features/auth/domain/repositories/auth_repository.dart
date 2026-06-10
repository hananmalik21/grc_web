import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/auth/domain/entities/app_user.dart';

abstract class AuthRepository {
  Future<Result<AppUser>> getCurrentUser();
}

