import 'package:grc/features/hiring/data/datasources/rec_lookups_remote_data_source.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/repositories/rec_lookups_repository.dart';

class RecLookupsRepositoryImpl implements RecLookupsRepository {
  const RecLookupsRepositoryImpl({required this.remoteDataSource});

  final RecLookupsRemoteDataSource remoteDataSource;

  @override
  Future<List<RecLookupType>> getLookupTypes({required int enterpriseId, int page = 1, int pageSize = 10}) async {
    final response = await remoteDataSource.getLookupTypes(enterpriseId: enterpriseId, page: page, pageSize: pageSize);
    return response.data
        .where((dto) => dto.isActive.toUpperCase() == 'Y' || dto.isActive.toUpperCase() == 'TRUE')
        .map((dto) => dto.toDomain())
        .toList();
  }

  @override
  Future<List<RecLookupValue>> getLookupValues({
    required int enterpriseId,
    required String lookupTypeCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await remoteDataSource.getLookupValues(
      enterpriseId: enterpriseId,
      lookupTypeCode: lookupTypeCode,
      page: page,
      pageSize: pageSize,
    );
    return response.data
        .where((dto) => dto.isEnabled.toUpperCase() == 'Y' || dto.isEnabled.toUpperCase() == 'TRUE')
        .map((dto) => dto.toDomain())
        .toList();
  }
}
