import '../../models/adjustments/salary_change_history.dart';
import '../../repositories/salary_change_history_repository.dart';

class GetSalaryChangeHistoryUseCase {
  final SalaryChangeHistoryRepository repository;

  GetSalaryChangeHistoryUseCase({required this.repository});

  Future<SalaryChangeHistoryPage> call({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  }) {
    return repository.getSalaryChangeHistory(
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
