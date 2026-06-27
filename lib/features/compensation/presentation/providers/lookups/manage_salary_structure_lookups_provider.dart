import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/lookups/comp_lookups_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/lookups/comp_lookups_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/domain/repositories/lookups/comp_lookups_repository.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryStructureDropdownData {
  final List<String> items;
  final Map<String, String> labelsByValue;
  final String hint;

  const SalaryStructureDropdownData({required this.items, required this.labelsByValue, required this.hint});

  String labelFor(String value) => labelsByValue[value] ?? value;
}

final _salaryStructureCompLookupsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _salaryStructureCompLookupsRemoteDataSourceProvider = Provider<CompLookupsRemoteDataSource>((ref) {
  return CompLookupsRemoteDataSourceImpl(apiClient: ref.watch(_salaryStructureCompLookupsApiClientProvider));
});

final _salaryStructureCompLookupsRepositoryProvider = Provider<CompLookupsRepository>((ref) {
  return CompLookupsRepositoryImpl(remoteDataSource: ref.watch(_salaryStructureCompLookupsRemoteDataSourceProvider));
});

final manageSalaryStructureCountryLookupValuesProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <CompLookupValue>[];

  final repo = ref.watch(_salaryStructureCompLookupsRepositoryProvider);
  final values = await repo.getLookupValues(tenantId: tenantId, lookupTypeCode: 'COMPONENT_LOCATION');
  final active = values.where((e) => e.isActive).toList()
    ..sort((a, b) => (a.displaySequence ?? 0).compareTo(b.displaySequence ?? 0));
  return active;
});

final manageSalaryStructureTypeLookupValuesProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <CompLookupValue>[];

  final repo = ref.watch(_salaryStructureCompLookupsRepositoryProvider);
  final values = await repo.getLookupValues(tenantId: tenantId, lookupTypeCode: 'SALARY_STRUCTURE_TYPE');
  final active = values.where((e) => e.isActive).toList()
    ..sort((a, b) => (a.displaySequence ?? 0).compareTo(b.displaySequence ?? 0));
  return active;
});

final manageSalaryStructureEmployeeCategoryLookupValuesProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <CompLookupValue>[];

  final repo = ref.watch(_salaryStructureCompLookupsRepositoryProvider);
  final values = await repo.getLookupValues(tenantId: tenantId, lookupTypeCode: 'EMPLOYEE_CATEGORY');
  final active = values.where((e) => e.isActive).toList()
    ..sort((a, b) => (a.displaySequence ?? 0).compareTo(b.displaySequence ?? 0));
  return active;
});

final manageSalaryStructureContractTypeLookupValuesProvider = FutureProvider<List<EmplLookupValue>>((ref) async {
  final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <EmplLookupValue>[];

  return ref.watch(emplLookupValuesForTypeProvider((enterpriseId: tenantId, typeCode: 'CONTRACT_TYPE')).future);
});

final manageSalaryStructureCurrencyLookupValuesProvider = FutureProvider<List<CompLookupValue>>((ref) async {
  final tenantId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <CompLookupValue>[];

  final repo = ref.watch(_salaryStructureCompLookupsRepositoryProvider);
  final values = await repo.getLookupValues(tenantId: tenantId, lookupTypeCode: 'CURRENCY');
  final active = values.where((e) => e.isActive).toList()
    ..sort((a, b) => (a.displaySequence ?? 0).compareTo(b.displaySequence ?? 0));
  return active;
});

final manageSalaryStructureCountryDropdownProvider = Provider<SalaryStructureDropdownData>((ref) {
  final async = ref.watch(manageSalaryStructureCountryLookupValuesProvider);

  final values = async.valueOrNull ?? const <CompLookupValue>[];
  final apiItems = values.map((e) => e.valueCode).toList();
  final labels = {for (final item in values) item.valueCode: item.valueName};

  final items = apiItems;
  final hint = async.isLoading ? 'Loading countries...' : (items.isEmpty ? 'No countries available' : 'Select Country');

  return SalaryStructureDropdownData(items: items, labelsByValue: labels, hint: hint);
});

final manageSalaryStructureTypeDropdownProvider = Provider<SalaryStructureDropdownData>((ref) {
  final async = ref.watch(manageSalaryStructureTypeLookupValuesProvider);

  final values = async.valueOrNull ?? const <CompLookupValue>[];
  final apiItems = values.map((e) => e.valueCode).toList();
  final labels = {for (final item in values) item.valueCode: item.valueName};

  final items = apiItems;
  final hint = async.isLoading ? 'Loading structure types...' : (items.isEmpty ? 'No types available' : 'Select Type');

  return SalaryStructureDropdownData(items: items, labelsByValue: labels, hint: hint);
});

final manageSalaryStructureEmployeeCategoryDropdownProvider = Provider<SalaryStructureDropdownData>((ref) {
  final async = ref.watch(manageSalaryStructureEmployeeCategoryLookupValuesProvider);

  final values = async.valueOrNull ?? const <CompLookupValue>[];
  final apiItems = values.map((e) => e.valueCode).toList();
  final labels = {for (final item in values) item.valueCode: item.valueName};

  final items = apiItems;
  final hint = async.isLoading
      ? 'Loading employee categories...'
      : (items.isEmpty ? 'No categories available' : 'Select Category');

  return SalaryStructureDropdownData(items: items, labelsByValue: labels, hint: hint);
});

final manageSalaryStructureCurrencyDropdownProvider = Provider<SalaryStructureDropdownData>((ref) {
  final async = ref.watch(manageSalaryStructureCurrencyLookupValuesProvider);

  final values = async.valueOrNull ?? const <CompLookupValue>[];
  final apiItems = values.map((e) => e.valueCode).toList();
  final labels = {for (final item in values) item.valueCode: item.valueName};

  final items = apiItems;
  final hint = async.isLoading
      ? 'Loading currencies...'
      : (items.isEmpty ? 'No currencies available' : 'Select Currency');

  return SalaryStructureDropdownData(items: items, labelsByValue: labels, hint: hint);
});
