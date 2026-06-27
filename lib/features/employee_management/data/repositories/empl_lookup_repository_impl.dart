import 'package:grc/features/employee_management/data/datasources/empl_lookup_remote_data_source.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_type.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/domain/repositories/empl_lookup_repository.dart';

class EmplLookupRepositoryImpl implements EmplLookupRepository {
  EmplLookupRepositoryImpl({required this.remoteDataSource});
  final EmplLookupRemoteDataSource remoteDataSource;

  @override
  Future<List<EmplLookupType>> getLookupTypes(int enterpriseId) async {
    final response = await remoteDataSource.getLookupTypes(enterpriseId);
    return response.data.map((dto) => EmplLookupType(typeCode: dto.typeCode, typeName: dto.typeName)).toList();
  }

  @override
  Future<List<EmplLookupValue>> getLookupValues(int enterpriseId, String lookupTypeCode) async {
    final response = await remoteDataSource.getLookupValues(enterpriseId, lookupTypeCode);
    return response.toDomain();
  }
}
