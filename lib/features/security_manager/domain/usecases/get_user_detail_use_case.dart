import '../models/user_detail_data.dart';
import '../repositories/user_management_repository.dart';

class GetUserDetailUseCase {
  const GetUserDetailUseCase(this._repository);

  final UserManagementRepository _repository;

  Future<UserDetailData> call({required String userGuid}) => _repository.getUserDetail(userGuid: userGuid);
}
