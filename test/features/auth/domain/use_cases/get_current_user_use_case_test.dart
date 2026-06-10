import 'package:flutter_test/flutter_test.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/auth/domain/entities/app_user.dart';
import 'package:grc_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:grc_web/features/auth/domain/use_cases/get_current_user_use_case.dart';

class _FakeAuthRepositorySuccess implements AuthRepository {
  @override
  Future<Result<AppUser>> getCurrentUser() async {
    return const Success(AppUser(id: '1', name: 'Test'));
  }
}

class _FakeAuthRepositoryFailure implements AuthRepository {
  @override
  Future<Result<AppUser>> getCurrentUser() async {
    return const FailureResult(NetworkFailure(message: 'offline'));
  }
}

void main() {
  test('GetCurrentUserUseCase returns user on success', () async {
    final useCase = GetCurrentUserUseCase(_FakeAuthRepositorySuccess());

    final result = await useCase();

    expect(
      result.when(
        success: (user) => user.name,
        failure: (_) => null,
      ),
      'Test',
    );
  });

  test('GetCurrentUserUseCase returns failure on error', () async {
    final useCase = GetCurrentUserUseCase(_FakeAuthRepositoryFailure());

    final result = await useCase();

    expect(
      result.when(
        success: (_) => null,
        failure: (f) => f.message,
      ),
      'offline',
    );
  });
}

