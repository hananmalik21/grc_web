import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/datasources/abs_lookups_remote_data_source.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/domain/repositories/abs_lookups_repository.dart';

class AbsLookupsRepositoryImpl implements AbsLookupsRepository {
  final AbsLookupsRemoteDataSource remoteDataSource;

  AbsLookupsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AbsLookup>> getLookups({required int tenantId}) async {
    try {
      final dto = await remoteDataSource.getLookups(tenantId: tenantId);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch ABS lookups: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<AbsLookupValue>> getLookupValues({required int lookupId, required int tenantId}) async {
    try {
      final dto = await remoteDataSource.getLookupValues(lookupId: lookupId, tenantId: tenantId);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: Failed to fetch ABS lookup values: ${e.toString()}', originalError: e);
    }
  }
}
