import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/security_manager/data/repositories/security_lookups/security_lookups_repository_impl.dart';
import 'package:grc/features/security_manager/domain/constants/security_lookup_type_codes.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_type.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/domain/repositories/security_lookups_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_security_lookup_types_use_case.dart';
import 'package:grc/features/security_manager/domain/usecases/get_security_lookup_values_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _securityLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final securityLookupsRepositoryProvider = Provider<SecurityLookupsRepository>((ref) {
  return SecurityLookupsRepositoryImpl(ref.watch(_securityLookupsApiClientProvider));
});

final getSecurityLookupTypesUseCaseProvider = Provider<GetSecurityLookupTypesUseCase>((ref) {
  return GetSecurityLookupTypesUseCase(ref.watch(securityLookupsRepositoryProvider));
});

final getSecurityLookupValuesUseCaseProvider = Provider<GetSecurityLookupValuesUseCase>((ref) {
  return GetSecurityLookupValuesUseCase(ref.watch(securityLookupsRepositoryProvider));
});

/// Lookup types for the current enterprise (security module).
final securityLookupTypesProvider = FutureProvider.autoDispose.family<List<SecurityLookupType>, int>((
  ref,
  enterpriseId,
) async {
  if (enterpriseId <= 0) return [];
  return ref.read(getSecurityLookupTypesUseCaseProvider).call(enterpriseId: enterpriseId);
});

final securityLookupValuesProvider = FutureProvider.autoDispose
    .family<List<SecurityLookupValue>, ({int enterpriseId, int lookupTypeId})>((ref, params) async {
      if (params.enterpriseId <= 0 || params.lookupTypeId <= 0) return [];
      return ref
          .read(getSecurityLookupValuesUseCaseProvider)
          .call(enterpriseId: params.enterpriseId, lookupTypeId: params.lookupTypeId);
    });

final dutyRoleCategoryLookupValuesProvider = FutureProvider.autoDispose.family<List<SecurityLookupValue>, int>((
  ref,
  enterpriseId,
) async {
  if (enterpriseId <= 0) return [];

  final types = await ref.read(getSecurityLookupTypesUseCaseProvider).call(enterpriseId: enterpriseId);
  SecurityLookupType? categoryType;
  for (final t in types) {
    if (t.typeCode == SecurityLookupTypeCodes.dutyRoleCategory) {
      categoryType = t;
      break;
    }
  }
  if (categoryType == null) return [];

  return ref
      .read(getSecurityLookupValuesUseCaseProvider)
      .call(enterpriseId: enterpriseId, lookupTypeId: categoryType.lookupTypeId);
});

final dataRoleDataTypeLookupValuesProvider = FutureProvider.autoDispose.family<List<SecurityLookupValue>, int>((
  ref,
  enterpriseId,
) async {
  if (enterpriseId <= 0) return [];

  final types = await ref.read(getSecurityLookupTypesUseCaseProvider).call(enterpriseId: enterpriseId);
  SecurityLookupType? dataTypeCategoryType;
  for (final type in types) {
    if (type.typeCode == SecurityLookupTypeCodes.dataTypeCategory) {
      dataTypeCategoryType = type;
      break;
    }
  }
  if (dataTypeCategoryType == null) return [];

  return ref
      .read(getSecurityLookupValuesUseCaseProvider)
      .call(enterpriseId: enterpriseId, lookupTypeId: dataTypeCategoryType.lookupTypeId);
});

final currencyCodeLookupValuesProvider = FutureProvider.autoDispose.family<List<SecurityLookupValue>, int>((
  ref,
  enterpriseId,
) async {
  if (enterpriseId <= 0) return [];

  final types = await ref.read(getSecurityLookupTypesUseCaseProvider).call(enterpriseId: enterpriseId);
  SecurityLookupType? currencyType;
  for (final type in types) {
    if (type.typeCode == SecurityLookupTypeCodes.currencyCode) {
      currencyType = type;
      break;
    }
  }
  if (currencyType == null) return [];

  return ref
      .read(getSecurityLookupValuesUseCaseProvider)
      .call(enterpriseId: enterpriseId, lookupTypeId: currencyType.lookupTypeId);
});
