import '../models/adjustments/salary_change_history.dart';

abstract class SalaryChangeHistoryRepository {
  Future<SalaryChangeHistoryPage> getSalaryChangeHistory({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  });
}
