import 'package:grc/features/hiring/data/dto/talent_pools_dto.dart';
import 'package:grc/features/hiring/domain/repositories/talent_pools_repository.dart';

class GetTalentPoolsUseCase {
  const GetTalentPoolsUseCase({required this.repository});

  final TalentPoolsRepository repository;

  Future<TalentPoolsPageDto> call({required int enterpriseId, int page = 1, int pageSize = 10}) {
    return repository.getTalentPools(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
  }
}
