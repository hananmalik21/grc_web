import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/auth/domain/entities/app_user.dart';
import 'package:grc_web/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser>> call() => _repository.getCurrentUser();
}

