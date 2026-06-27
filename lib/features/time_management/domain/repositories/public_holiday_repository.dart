import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';

/// Repository interface for public holiday operations
abstract class PublicHolidayRepository {
  Future<PaginatedHolidays> getHolidays({
    required int tenantId,
    int page = 1,
    int pageSize = 10,
    String? search,
    String? year,
    String? type,
  });

  Future<PublicHoliday> createHoliday({
    required int tenantId,
    required String nameEn,
    required String nameAr,
    required DateTime date,
    required int year,
    required HolidayType type,
    required String descriptionEn,
    required String descriptionAr,
    required String appliesTo,
    required bool isPaid,
  });

  Future<PublicHoliday> updateHoliday({
    required int holidayId,
    required int tenantId,
    required String nameEn,
    required String nameAr,
    required DateTime date,
    required int year,
    required HolidayType type,
    required String descriptionEn,
    required String descriptionAr,
    required String appliesTo,
    required bool isPaid,
  });

  Future<void> deleteHoliday(int holidayId, {required int tenantId, bool hard = true});
}
