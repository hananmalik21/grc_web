import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';
import 'package:grc/features/time_management/domain/repositories/public_holiday_repository.dart';

/// Use case for creating a public holiday
class CreatePublicHolidayUseCase {
  final PublicHolidayRepository repository;

  const CreatePublicHolidayUseCase({required this.repository});

  Future<PublicHoliday> execute({
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
  }) async {
    return await repository.createHoliday(
      tenantId: tenantId,
      nameEn: nameEn,
      nameAr: nameAr,
      date: date,
      year: year,
      type: type,
      descriptionEn: descriptionEn,
      descriptionAr: descriptionAr,
      appliesTo: appliesTo,
      isPaid: isPaid,
    );
  }
}
