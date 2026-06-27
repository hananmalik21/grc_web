import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/datasources/lookups/comp_lookups_remote_data_source.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_graph_count_dto.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_type.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/repositories/lookups/comp_lookups_repository.dart';

class CompLookupsRepositoryImpl implements CompLookupsRepository {
  final CompLookupsRemoteDataSource remoteDataSource;

  CompLookupsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CompLookupType>> getLookupTypes() async {
    try {
      final dtos = await remoteDataSource.getLookupTypes();
      return dtos.map((d) => d.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch lookup types: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompLookupValue>> getLookupValues({required int tenantId, required String lookupTypeCode}) async {
    try {
      final dtos = await remoteDataSource.getLookupValues(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
      final values = dtos.map((d) => d.toDomain()).toList();
      values.sort((a, b) => (a.displaySequence ?? 999999).compareTo(b.displaySequence ?? 999999));
      return values;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch lookup values: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompLookupGraphCountItemDto>> getGraphCounts({
    required int tenantId,
    required String lookupTypeCode,
  }) async {
    try {
      final dtos = await remoteDataSource.getGraphCounts(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
      dtos.sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
      return dtos;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch graph counts: ${e.toString()}', originalError: e);
    }
  }
}
