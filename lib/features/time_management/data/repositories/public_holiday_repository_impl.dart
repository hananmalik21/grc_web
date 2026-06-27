import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/data/datasources/public_holiday_remote_datasource.dart';
import 'package:grc/features/time_management/data/models/public_holiday_model.dart';
import 'package:grc/features/time_management/domain/models/public_holiday.dart';
import 'package:grc/features/time_management/domain/repositories/public_holiday_repository.dart';
import 'package:intl/intl.dart';

/// Repository implementation for public holiday operations
class PublicHolidayRepositoryImpl implements PublicHolidayRepository {
  final PublicHolidayRemoteDataSource remoteDataSource;
  final int tenantId;

  const PublicHolidayRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedHolidays> getHolidays({
    required int tenantId,
    int page = 1,
    int pageSize = 10,
    String? search,
    String? year,
    String? type,
  }) async {
    final response = await remoteDataSource.getHolidays(
      tenantId: tenantId,
      page: page,
      pageSize: pageSize,
      search: search,
      year: year,
      type: type,
    );

    return response.toEntity();
  }

  @override
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
  }) async {
    final requestBody = {
      'TENANT_ID': tenantId,
      'HOLIDAY_NAME_EN': nameEn,
      'HOLIDAY_NAME_AR': nameAr,
      'HOLIDAY_DATE': DateFormat('yyyy-MM-dd').format(date),
      'HOLIDAY_YEAR': year,
      'HOLIDAY_TYPE': type.apiValue.toUpperCase(),
      'DESCRIPTION_EN': descriptionEn,
      'DESCRIPTION_AR': descriptionAr,
      'APPLIES_TO': appliesTo,
      'STATUS': 'ACTIVE',
    };

    final response = await remoteDataSource.createHoliday(requestBody);

    if (response['data'] != null && response['data'] is Map<String, dynamic>) {
      final holidayModel = PublicHolidayModel.fromJson(response['data'] as Map<String, dynamic>);
      return holidayModel.toEntity();
    }

    throw Exception('Invalid response format from server');
  }

  @override
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
  }) async {
    final requestBody = {
      'TENANT_ID': tenantId,
      'HOLIDAY_NAME_EN': nameEn,
      'HOLIDAY_NAME_AR': nameAr,
      'HOLIDAY_DATE': DateFormat('yyyy-MM-dd').format(date),
      'HOLIDAY_YEAR': year,
      'HOLIDAY_TYPE': type.apiValue.toUpperCase(),
      'DESCRIPTION_EN': descriptionEn,
      'DESCRIPTION_AR': descriptionAr,
      'APPLIES_TO': appliesTo,
      'STATUS': 'ACTIVE',
    };

    final response = await remoteDataSource.updateHoliday(holidayId, requestBody);

    if (response['data'] != null && response['data'] is Map<String, dynamic>) {
      final holidayModel = PublicHolidayModel.fromJson(response['data'] as Map<String, dynamic>);
      return holidayModel.toEntity();
    }

    throw Exception('Invalid response format from server');
  }

  @override
  Future<void> deleteHoliday(int holidayId, {required int tenantId, bool hard = true}) async {
    await remoteDataSource.deleteHoliday(holidayId, tenantId: tenantId, hard: hard);
  }
}
