import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/user_detail_data.dart';
import '../../../domain/usecases/get_user_detail_use_case.dart';
import 'user_management_provider.dart';

final _getUserDetailUseCaseProvider = Provider<GetUserDetailUseCase>((ref) {
  return GetUserDetailUseCase(ref.watch(userManagementRepositoryProvider));
});

final userDetailProvider = FutureProvider.family.autoDispose<UserDetailData, String>((ref, userGuid) async {
  final useCase = ref.watch(_getUserDetailUseCaseProvider);
  return useCase(userGuid: userGuid);
});
