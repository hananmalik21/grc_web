import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_config.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/exceptions.dart';
import '../../domain/models/attendance_summary/attendance_summary_page.dart';
import '../../domain/repositories/attendance_summary_repository.dart';
import '../dto/attendance_summary_response_dto.dart';

class AttendanceSummaryRepositoryImpl implements AttendanceSummaryRepository {
  final ApiClient? _apiClient;

  AttendanceSummaryRepositoryImpl({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<AttendanceSummaryPage> getAttendanceSummaryRecords({
    required String companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    String? fromDate,
    String? toDate,
    int? page,
    int? pageSize,
  }) async {
    try {
      final effectivePage = page ?? 1;
      final effectivePageSize = pageSize ?? 10;
      final effectiveFromDate = fromDate ?? date;
      final effectiveToDate = toDate ?? date;
      final response = await _apiClient?.get(
        ApiEndpoints.tmAttendanceSummary,
        queryParameters: {
          'enterprise_id': companyId,
          'org_unit_id': ?orgUnitId,
          'level_code': ?levelCode,
          'from_date': ?effectiveFromDate,
          'to_date': ?effectiveToDate,
          'page': effectivePage.toString(),
          'page_size': effectivePageSize.toString(),
        },
      );

      final dto = AttendanceSummaryResponseDto.fromApiResponse(response);
      final records = dto.items.map((e) => e.toDomain()).toList();

      final pagination = dto.pagination;
      if (pagination == null) {
        final hasNext = records.length >= effectivePageSize;
        final hasPrevious = effectivePage > 1;
        final totalPages = hasNext ? (effectivePage + 1) : effectivePage;
        final total = hasNext
            ? (effectivePage * effectivePageSize + 1)
            : ((effectivePage - 1) * effectivePageSize + records.length);

        return AttendanceSummaryPage(
          records: records,
          page: effectivePage,
          pageSize: effectivePageSize,
          total: total,
          totalPages: totalPages,
          hasNext: hasNext,
          hasPrevious: hasPrevious,
        );
      }

      final total = pagination.total;
      final resolvedPageSize = pagination.pageSize;
      final resolvedPage = pagination.page;
      final totalPages = pagination.totalPages == 0
          ? (total == 0 ? 1 : (total / resolvedPageSize).ceil())
          : pagination.totalPages;
      final hasNext = pagination.hasNext || resolvedPage < totalPages;
      final hasPrevious = pagination.hasPrevious || resolvedPage > 1;

      return AttendanceSummaryPage(
        records: records,
        page: resolvedPage,
        pageSize: resolvedPageSize,
        total: total,
        totalPages: totalPages,
        hasNext: hasNext,
        hasPrevious: hasPrevious,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to load attendance summary: ${e.toString()}', originalError: e);
    }
  }
}
