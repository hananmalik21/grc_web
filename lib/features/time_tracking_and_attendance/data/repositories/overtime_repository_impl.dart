import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import '../../domain/models/overtime/overtime_requests_page.dart';
import '../../domain/repositories/overtime_repository.dart';
import '../datasources/overtime_requests_remote_data_source.dart';
import '../dto/create_overtime_request_dto.dart';
import '../dto/update_overtime_request_dto.dart';

class OvertimeRepositoryImpl implements OvertimeRepository {
  final OvertimeRequestsRemoteDataSource _requestsDataSource;

  OvertimeRepositoryImpl({OvertimeRequestsRemoteDataSource? requestsDataSource})
    : _requestsDataSource =
          requestsDataSource ?? OvertimeRequestsRemoteDataSourceImpl(apiClient: ApiClient(baseUrl: ApiConfig.baseUrl));

  @override
  Future<void> createOvertimeRequest({
    required int tenantId,
    required String employeeGuid,
    required int attendanceDayId,
    required double requestedHours,
    required String reason,
    required int otConfigId,
    required int otRateTypeId,
    OvertimeStatus status = OvertimeStatus.submitted,
    String actor = 'admin',
  }) async {
    final dto = CreateOvertimeRequestDto(
      tenantId: tenantId,
      employeeGuid: employeeGuid,
      attendanceDayId: attendanceDayId,
      requestedHours: requestedHours,
      reason: reason,
      otConfigId: otConfigId,
      otRateTypeId: otRateTypeId,
      status: status,
      actor: actor,
    );
    await _requestsDataSource.createOvertimeRequest(dto);
  }

  @override
  Future<OvertimeRequestsPage> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? searchQuery,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    final dto = await _requestsDataSource.getOvertimeRequests(
      tenantId: tenantId,
      status: status,
      searchQuery: searchQuery,
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      page: page,
      pageSize: pageSize,
    );

    final records = dto.items.map((e) => e.toDomain()).toList();
    final pag = dto.pagination;

    return OvertimeRequestsPage(
      records: records,
      page: pag.page,
      pageSize: pag.limit,
      total: pag.total,
      hasMore: pag.hasMore,
    );
  }

  @override
  Future<Map<String, dynamic>?> approveOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  }) async {
    return _requestsDataSource.approveOvertimeRequest(otRequestGuid, tenantId: tenantId, actor: actor);
  }

  @override
  Future<Map<String, dynamic>?> rejectOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  }) async {
    return _requestsDataSource.rejectOvertimeRequest(otRequestGuid, tenantId: tenantId, actor: actor);
  }

  @override
  Future<Map<String, dynamic>?> updateOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    required double requestedHours,
    required String reason,
    String actor = 'admin',
  }) async {
    final dto = UpdateOvertimeRequestDto(
      tenantId: tenantId,
      requestedHours: requestedHours,
      reason: reason,
      actor: actor,
    );
    return _requestsDataSource.updateOvertimeRequest(otRequestGuid, dto: dto);
  }

  @override
  Future<Map<String, dynamic>?> cancelOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  }) async {
    return _requestsDataSource.cancelOvertimeRequest(otRequestGuid, tenantId: tenantId, actor: actor);
  }
}
