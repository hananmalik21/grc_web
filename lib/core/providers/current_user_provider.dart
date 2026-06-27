import 'package:grc/features/auth/data/datasources/auth_local_storage.dart';
import 'package:grc/features/auth/data/datasources/hive_auth_local_storage.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/features/security_manager/domain/models/user_detail_data.dart';
import 'package:grc/features/security_manager/domain/usecases/get_user_detail_use_case.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_management_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _currentUserAuthStorageProvider = Provider<AuthLocalStorage>((ref) {
  return HiveAuthLocalStorage();
});

final _currentUserUseCaseProvider = Provider<GetUserDetailUseCase>((ref) {
  return GetUserDetailUseCase(ref.watch(userManagementRepositoryProvider));
});

final currentUserProvider = FutureProvider<UserDetailData?>((ref) async {
  final authState = ref.watch(authProvider);

  if (!authState.isAuthenticated) return null;

  final storage = ref.read(_currentUserAuthStorageProvider);
  final userGuid = await storage.getUserGuid();
  if (userGuid == null || userGuid.isEmpty) return null;

  final useCase = ref.read(_currentUserUseCaseProvider);
  return useCase(userGuid: userGuid);
});

final currentUserPermissionsProvider = Provider<Set<String>>((ref) {
  return ref.watch(currentUserProvider).valueOrNull?.permissionKeys.toSet() ?? const {};
});
