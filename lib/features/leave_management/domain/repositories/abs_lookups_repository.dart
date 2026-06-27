import 'package:grc/features/leave_management/domain/models/abs_lookup.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';

abstract class AbsLookupsRepository {
  Future<List<AbsLookup>> getLookups({required int tenantId});
  Future<List<AbsLookupValue>> getLookupValues({required int lookupId, required int tenantId});
}
