import 'package:grc/features/payroll/data/datasources/pay_lookups_remote_data_source.dart';
import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';
import 'package:grc/features/payroll/domain/repositories/pay_lookups_repository.dart';

class PayLookupsRepositoryImpl implements PayLookupsRepository {
  const PayLookupsRepositoryImpl({required this.remoteDataSource});

  final PayLookupsRemoteDataSource remoteDataSource;

  @override
  Future<List<PayLookupValue>> getLookupValues({
    required int enterpriseId,
    required String typeCode,
    int page = 1,
    int limit = 100,
    String activeFlag = 'Y',
  }) async {
    final response = await remoteDataSource.getLookupValues(
      enterpriseId: enterpriseId,
      typeCode: typeCode,
      page: page,
      limit: limit,
      activeFlag: activeFlag,
    );

    final values = response.toDomain().where((value) => value.isActive).toList()
      ..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));

    return values;
  }
}
