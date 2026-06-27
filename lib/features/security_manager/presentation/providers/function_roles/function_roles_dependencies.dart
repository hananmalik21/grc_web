import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/security_manager/data/repositories/function_roles/function_roles_repository_impl.dart';
import 'package:grc/features/security_manager/domain/repositories/function_roles_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_function_roles_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final functionRolesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final functionRolesRepositoryProvider = Provider<FunctionRolesRepository>((ref) {
  return FunctionRolesRepositoryImpl(ref.watch(functionRolesApiClientProvider));
});

final getFunctionRolesUseCaseProvider = Provider<GetFunctionRolesUseCase>((ref) {
  return GetFunctionRolesUseCase(ref.watch(functionRolesRepositoryProvider));
});
