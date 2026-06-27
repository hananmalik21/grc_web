import 'package:grc/features/leave_management/data/datasources/leave_types_remote_data_source.dart';
import 'package:grc/features/leave_management/data/dto/leave_type_dto.dart';
import 'package:grc/features/leave_management/domain/models/api_leave_type.dart';
import 'package:grc/features/leave_management/domain/repositories/leave_types_repository.dart';

class LeaveTypesRepositoryImpl implements LeaveTypesRepository {
  final LeaveTypesRemoteDataSource _remoteDataSource;

  LeaveTypesRepositoryImpl({required LeaveTypesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<List<ApiLeaveType>> getLeaveTypes({String? search, int? tenantId}) async {
    final dtos = await _remoteDataSource.getLeaveTypes(search: search, tenantId: tenantId);
    return dtos.map((dto) => _mapToDomain(dto)).toList();
  }

  ApiLeaveType _mapToDomain(LeaveTypeDto dto) {
    return ApiLeaveType(
      id: dto.leaveTypeId,
      guid: dto.leaveTypeGuid,
      tenantId: dto.tenantId,
      code: dto.leaveCode,
      nameEn: dto.leaveNameEn,
      nameAr: dto.leaveNameAr,
      descriptionEn: dto.descriptionEn,
      descriptionAr: dto.descriptionAr,
      isPaid: dto.isPaid == 'Y',
      requiresDocuments: dto.requiresDocuments == 'Y',
      maxDaysPerYear: dto.maxDaysPerYear,
      isActive: dto.status == 'ACTIVE',
    );
  }
}
