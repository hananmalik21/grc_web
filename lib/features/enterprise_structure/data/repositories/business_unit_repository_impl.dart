import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/business_unit_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/business_unit_repository.dart';

/// Implementation of BusinessUnitRepository
class BusinessUnitRepositoryImpl implements BusinessUnitRepository {
  final BusinessUnitRemoteDataSource remoteDataSource;

  BusinessUnitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PaginatedBusinessUnits> getBusinessUnits({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final dto = await remoteDataSource.getBusinessUnits(
        search: search,
        page: page,
        pageSize: pageSize,
      );
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<BusinessUnitOverview> createBusinessUnit(Map<String, dynamic> businessUnitData) async {
    try {
      final dto = await remoteDataSource.createBusinessUnit(businessUnitData);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<BusinessUnitOverview> updateBusinessUnit(int businessUnitId, Map<String, dynamic> businessUnitData) async {
    try {
      final dto = await remoteDataSource.updateBusinessUnit(businessUnitId, businessUnitData);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteBusinessUnit(int businessUnitId, {bool hard = true}) async {
    try {
      await remoteDataSource.deleteBusinessUnit(businessUnitId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Repository error: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

