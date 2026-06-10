import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc_web/core/network/network_providers.dart';
import 'package:grc_web/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:grc_web/features/auth/data/data_sources/auth_remote_data_source_impl.dart';
import 'package:grc_web/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:grc_web/features/auth/domain/entities/app_user.dart';
import 'package:grc_web/features/auth/domain/repositories/auth_repository.dart';
import 'package:grc_web/features/auth/domain/use_cases/get_current_user_use_case.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

class AuthUserNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async => null;

  Future<void> loadCurrentUser() async {
    state = const AsyncLoading();
    final result = await ref.read(getCurrentUserUseCaseProvider)();
    result.when(
      success: (user) => state = AsyncData(user),
      failure: (failure) => state = AsyncError(failure, StackTrace.current),
    );
  }
}

final authUserProvider = AsyncNotifierProvider<AuthUserNotifier, AppUser?>(AuthUserNotifier.new);

