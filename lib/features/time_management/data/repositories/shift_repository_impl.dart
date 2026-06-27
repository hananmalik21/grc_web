import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/datasources/shift_remote_datasource.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/repositories/shift_repository.dart';

/// Repository implementation for shift operations
class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftRemoteDataSource remoteDataSource;
  final int tenantId;

  const ShiftRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedShifts> getShifts({String? search, bool? isActive, int page = 1, int pageSize = 10}) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('pageSize must be between 1 and 100');
      }

      final dto = await remoteDataSource.getShifts(
        tenantId: tenantId,
        search: search,
        isActive: isActive,
        page: page,
        pageSize: pageSize,
      );

      final shifts = dto.data.isEmpty
          ? <ShiftOverview>[]
          : dto.data
                .map((shiftDto) {
                  try {
                    return shiftDto.toDomain();
                  } catch (e) {
                    return null;
                  }
                })
                .whereType<ShiftOverview>()
                .toList();

      final paginationPage = dto.meta.pagination.page;
      final paginationPageSize = dto.meta.pagination.pageSize;
      final paginationTotal = dto.meta.pagination.total;

      final validPage = paginationPage < 1 ? 1 : paginationPage;
      final validPageSize = paginationPageSize < 1 ? pageSize : paginationPageSize;
      final validTotal = paginationTotal < 0 ? 0 : paginationTotal;
      final validTotalPages = validPageSize > 0 ? (validTotal / validPageSize).ceil() : 0;

      final pagination = PaginationInfo(
        currentPage: validPage,
        totalPages: validTotalPages,
        totalItems: validTotal,
        pageSize: validPageSize,
        hasNext: validPage < validTotalPages,
        hasPrevious: validPage > 1,
      );

      return PaginatedShifts(shifts: shifts, pagination: pagination);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get shifts: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ShiftOverview> createShift({required Map<String, dynamic> shiftData}) async {
    try {
      return await remoteDataSource.createShift(tenantId: tenantId, shiftData: shiftData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create shift: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ShiftOverview> updateShift({required int shiftId, required Map<String, dynamic> shiftData}) async {
    try {
      return await remoteDataSource.updateShift(shiftId: shiftId, tenantId: tenantId, shiftData: shiftData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update shift: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteShift({required int shiftId, required bool hard}) async {
    try {
      await remoteDataSource.deleteShift(shiftId: shiftId, tenantId: tenantId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete shift: ${e.toString()}', originalError: e);
    }
  }
}
