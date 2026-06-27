import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/workforce_structure/domain/models/ent_lookup_type.dart';
import 'package:grc/features/workforce_structure/domain/models/ent_lookup_value_input.dart';

abstract class EntLookupRepository {
  Future<List<EmplLookupValue>> getLookupValues(int enterpriseId, String lookupTypeCode);
  Future<List<EntLookupType>> getLookupTypes(int enterpriseId);
  Future<void> createLookupValuesBulk({
    required int enterpriseId,
    required String lookupTypeCode,
    required List<EntLookupValueInput> values,
  });
}
