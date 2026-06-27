import 'package:grc/features/security_manager/domain/models/security_lookup_type.dart';
import 'package:grc/features/security_manager/domain/repositories/security_lookups_repository.dart';

class GetSecurityLookupTypesUseCase {
  const GetSecurityLookupTypesUseCase(this._repository);

  final SecurityLookupsRepository _repository;

  Future<List<SecurityLookupType>> call({required int enterpriseId}) {
    return _repository.getLookupTypes(enterpriseId: enterpriseId);
  }
}
