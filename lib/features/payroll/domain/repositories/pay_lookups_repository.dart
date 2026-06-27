import 'package:grc/features/payroll/domain/models/pay_lookup_value.dart';

abstract class PayLookupsRepository {
  Future<List<PayLookupValue>> getLookupValues({
    required int enterpriseId,
    required String typeCode,
    int page,
    int limit,
    String activeFlag,
  });
}
