import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class PublicHoliday {
  final int id;
  final int tenantId;
  final String nameEn;
  final String nameAr;
  final DateTime date;
  final int year;
  final HolidayType type;
  final HolidayPaymentStatus paymentStatus;
  final String descriptionEn;
  final String descriptionAr;
  final String appliesTo;
  final bool isActive;
  final DateTime? createdAt;
  final String? createdBy;
  final DateTime? updatedAt;
  final String? updatedBy;

  const PublicHoliday({
    required this.id,
    required this.tenantId,
    required this.nameEn,
    required this.nameAr,
    required this.date,
    required this.year,
    required this.type,
    required this.paymentStatus,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.appliesTo,
    required this.isActive,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });
}

/// Domain entity for paginated holidays response
class PaginatedHolidays {
  final List<PublicHoliday> holidays;
  final PaginationInfo pagination;

  const PaginatedHolidays({required this.holidays, required this.pagination});
}
