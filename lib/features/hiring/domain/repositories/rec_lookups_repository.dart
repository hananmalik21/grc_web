import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';

abstract class RecLookupsRepository {
  Future<List<RecLookupType>> getLookupTypes({required int enterpriseId, int page, int pageSize});

  Future<List<RecLookupValue>> getLookupValues({
    required int enterpriseId,
    required String lookupTypeCode,
    int page,
    int pageSize,
  });
}
