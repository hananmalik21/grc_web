import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_graph_count_dto.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_type.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';

abstract class CompLookupsRepository {
  Future<List<CompLookupType>> getLookupTypes();

  Future<List<CompLookupValue>> getLookupValues({required int tenantId, required String lookupTypeCode});

  Future<List<CompLookupGraphCountItemDto>> getGraphCounts({required int tenantId, required String lookupTypeCode});
}
