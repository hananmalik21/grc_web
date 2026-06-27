import 'package:grc/features/security_manager/domain/models/security_lookup_type.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';

abstract class SecurityLookupsRepository {
  Future<List<SecurityLookupType>> getLookupTypes({required int enterpriseId});

  Future<List<SecurityLookupValue>> getLookupValues({required int enterpriseId, required int lookupTypeId});
}
