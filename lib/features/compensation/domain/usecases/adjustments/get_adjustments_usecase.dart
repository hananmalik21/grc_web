import '../../models/adjustments/adjustments_page.dart';
import '../../repositories/adjustments_repository.dart';

class GetAdjustmentsUseCase {
  final AdjustmentsRepository repository;

  GetAdjustmentsUseCase({required this.repository});

  Future<AdjustmentsPage> call({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  }) {
    return repository.getAdjustments(
      enterpriseId: enterpriseId,
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      status: status,
      department: department,
      region: region,
    );
  }
}
