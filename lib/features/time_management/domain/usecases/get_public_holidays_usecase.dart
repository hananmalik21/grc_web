import 'package:grc/features/time_management/domain/models/public_holiday.dart';
import 'package:grc/features/time_management/domain/repositories/public_holiday_repository.dart';

/// Use case for getting public holidays
class GetPublicHolidaysUseCase {
  final PublicHolidayRepository repository;

  const GetPublicHolidaysUseCase({required this.repository});

  Future<PaginatedHolidays> call({
    required int tenantId,
    int page = 1,
    int pageSize = 10,
    String? search,
    String? year,
    String? type,
  }) {
    return repository.getHolidays(
      tenantId: tenantId,
      page: page,
      pageSize: pageSize,
      search: search,
      year: year,
      type: type,
    );
  }
}
