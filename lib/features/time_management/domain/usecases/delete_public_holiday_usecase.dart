import 'package:grc/features/time_management/domain/repositories/public_holiday_repository.dart';

class DeletePublicHolidayUseCase {
  final PublicHolidayRepository repository;

  const DeletePublicHolidayUseCase({required this.repository});

  Future<void> execute(int holidayId, {required int tenantId, bool hard = true}) async {
    return await repository.deleteHoliday(holidayId, tenantId: tenantId, hard: hard);
  }
}
