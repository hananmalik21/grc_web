import 'package:grc/features/hiring/domain/repositories/talent_pools_repository.dart';

class CreateTalentPoolUseCase {
  const CreateTalentPoolUseCase({required this.repository});

  final TalentPoolsRepository repository;

  Future<Map<String, dynamic>> call({required int enterpriseId, required String poolName, required String createdBy}) {
    return repository.createTalentPool(enterpriseId: enterpriseId, poolName: poolName, createdBy: createdBy);
  }
}
