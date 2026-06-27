import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/repositories/lookups/comp_lookups_repository.dart';

class GetCompLookupValuesUseCase {
  final CompLookupsRepository repository;

  GetCompLookupValuesUseCase({required this.repository});

  Future<List<CompLookupValue>> call({required int tenantId, required String lookupTypeCode}) {
    return repository.getLookupValues(tenantId: tenantId, lookupTypeCode: lookupTypeCode);
  }
}
