import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/dto/shift_dto.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';

/// Remote data source for shift operations
abstract class ShiftRemoteDataSource {
  Future<PaginatedShiftsDto> getShifts({
    required int tenantId,
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  });

  Future<ShiftOverview> createShift({required int tenantId, required Map<String, dynamic> shiftData});

  Future<ShiftOverview> updateShift({
    required int shiftId,
    required int tenantId,
    required Map<String, dynamic> shiftData,
  });

  Future<void> deleteShift({required int shiftId, required int tenantId, required bool hard});
}

class ShiftRemoteDataSourceImpl implements ShiftRemoteDataSource {
  final ApiClient apiClient;

  const ShiftRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedShiftsDto> getShifts({
    required int tenantId,
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (search != null) {
        final trimmedSearch = search.trim();
        if (trimmedSearch.isNotEmpty) {
          queryParameters['search'] = trimmedSearch;
        }
      }

      if (isActive != null) {
        queryParameters['status'] = isActive ? 'ACTIVE' : 'INACTIVE';
      }

      final response = await apiClient.get(ApiEndpoints.tmShifts, queryParameters: queryParameters);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      return PaginatedShiftsDto.fromJson(response);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to fetch shifts: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ShiftOverview> createShift({required int tenantId, required Map<String, dynamic> shiftData}) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final response = await apiClient.post(ApiEndpoints.tmShifts, body: shiftData);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;

        // Optionally validate response status if present
        if (response.containsKey('status')) {
          final status = response['status'];
          if (status is bool && !status) {
            final message = response['message'] as String? ?? 'Failed to create shift';
            throw ValidationException(message);
          }
        }
      } else {
        data = response;
      }

      return ShiftOverview.fromJson(data);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to create shift: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ShiftOverview> updateShift({
    required int shiftId,
    required int tenantId,
    required Map<String, dynamic> shiftData,
  }) async {
    try {
      if (shiftId <= 0) {
        throw ValidationException('shift_id must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final endpoint = ApiEndpoints.tmShiftById(shiftId);
      final queryParameters = <String, String>{'tenant_id': tenantId.toString()};
      final response = await apiClient.put(endpoint, body: shiftData, queryParameters: queryParameters);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;

        if (response.containsKey('status')) {
          final status = response['status'];
          if (status is bool && !status) {
            final message = response['message'] as String? ?? 'Failed to update shift';
            throw ValidationException(message);
          }
        }
      } else {
        data = response;
      }

      return ShiftOverview.fromJson(data);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to update shift: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteShift({required int shiftId, required int tenantId, required bool hard}) async {
    try {
      if (shiftId <= 0) {
        throw ValidationException('shift_id must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final queryParameters = <String, String>{'tenant_id': tenantId.toString(), 'hard': hard.toString()};

      final endpoint = ApiEndpoints.tmShiftById(shiftId);
      final response = await apiClient.delete(endpoint, queryParameters: queryParameters);

      if (response.containsKey('status')) {
        final status = response['status'];
        if (status is bool && !status) {
          final message = response['message'] as String? ?? 'Failed to delete shift';
          throw ValidationException(message);
        }
      }

      final data = response['data'];
      if (data != null && data != shiftId) {
        throw ValidationException('Delete response data mismatch');
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete shift: ${e.toString()}', originalError: e);
    }
  }
}
