import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/enterprise_structure/data/datasources/business_unit_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/company_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/department_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/division_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/enterprise_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/enterprise_structure_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/org_structure_level_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/org_unit_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/structure_level_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/structure_list_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/datasources/structure_delete_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/repositories/business_unit_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/company_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/department_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/division_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/enterprise_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/enterprise_structure_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/org_structure_level_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/org_unit_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/structure_level_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/structure_list_repository_impl.dart';
import 'package:grc/features/enterprise_structure/data/repositories/structure_delete_repository_impl.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/create_business_unit_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/create_company_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/create_division_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_business_unit_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_company_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_division_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/create_department_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_business_units_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_departments_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/update_department_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_department_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/business_unit_management_provider.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/update_business_unit_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/update_company_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/update_division_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_active_levels_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_org_units_paginated_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/create_org_unit_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/update_org_unit_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_org_unit_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_structure_levels_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_structure_list_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/save_enterprise_structure_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/delete_structure_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/delete_structure_provider.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart'
    show StructureListNotifier, StructureListState;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final structureLevelRemoteDataSourceProvider = Provider<StructureLevelRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StructureLevelRemoteDataSourceImpl(apiClient: apiClient);
});

final structureLevelRepositoryProvider = Provider<StructureLevelRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(structureLevelRemoteDataSourceProvider);
  return StructureLevelRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getStructureLevelsUseCaseProvider = Provider<GetStructureLevelsUseCase>((ref) {
  final repository = ref.watch(structureLevelRepositoryProvider);
  return GetStructureLevelsUseCase(repository: repository);
});

final enterpriseStructureRemoteDataSourceProvider = Provider<EnterpriseStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EnterpriseStructureRemoteDataSourceImpl(apiClient: apiClient);
});

final enterpriseStructureRepositoryProvider = Provider<EnterpriseStructureRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(enterpriseStructureRemoteDataSourceProvider);
  return EnterpriseStructureRepositoryImpl(remoteDataSource: remoteDataSource);
});

final saveEnterpriseStructureUseCaseProvider = Provider<SaveEnterpriseStructureUseCase>((ref) {
  final repository = ref.watch(enterpriseStructureRepositoryProvider);
  return SaveEnterpriseStructureUseCase(repository: repository);
});

final enterpriseRemoteDataSourceProvider = Provider<EnterpriseRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return EnterpriseRemoteDataSourceImpl(apiClient: apiClient);
});

final enterpriseRepositoryProvider = Provider<EnterpriseRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(enterpriseRemoteDataSourceProvider);
  return EnterpriseRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getEnterprisesUseCaseProvider = Provider<GetEnterprisesUseCase>((ref) {
  final repository = ref.watch(enterpriseRepositoryProvider);
  return GetEnterprisesUseCase(repository: repository);
});

final structureListRemoteDataSourceProvider = Provider<StructureListRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StructureListRemoteDataSourceImpl(apiClient: apiClient);
});

final structureListRepositoryProvider = Provider<StructureListRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(structureListRemoteDataSourceProvider);
  return StructureListRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getStructureListUseCaseProvider = Provider<GetStructureListUseCase>((ref) {
  final repository = ref.watch(structureListRepositoryProvider);
  return GetStructureListUseCase(repository: repository);
});

final companyRemoteDataSourceProvider = Provider<CompanyRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return CompanyRemoteDataSourceImpl(apiClient: apiClient);
});

final companyRepositoryProvider = Provider<CompanyRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(companyRemoteDataSourceProvider);
  return CompanyRepositoryImpl(remoteDataSource: remoteDataSource);
});

final createCompanyUseCaseProvider = Provider<CreateCompanyUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return CreateCompanyUseCase(repository: repository);
});

final updateCompanyUseCaseProvider = Provider<UpdateCompanyUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return UpdateCompanyUseCase(repository: repository);
});

final deleteCompanyUseCaseProvider = Provider<DeleteCompanyUseCase>((ref) {
  final repository = ref.watch(companyRepositoryProvider);
  return DeleteCompanyUseCase(repository: repository);
});

final divisionRemoteDataSourceProvider = Provider<DivisionRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DivisionRemoteDataSourceImpl(apiClient: apiClient);
});

final divisionRepositoryProvider = Provider<DivisionRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(divisionRemoteDataSourceProvider);
  return DivisionRepositoryImpl(remoteDataSource: remoteDataSource);
});

final createDivisionUseCaseProvider = Provider<CreateDivisionUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return CreateDivisionUseCase(repository: repository);
});

final updateDivisionUseCaseProvider = Provider<UpdateDivisionUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return UpdateDivisionUseCase(repository: repository);
});

final deleteDivisionUseCaseProvider = Provider<DeleteDivisionUseCase>((ref) {
  final repository = ref.watch(divisionRepositoryProvider);
  return DeleteDivisionUseCase(repository: repository);
});

final businessUnitRemoteDataSourceProvider = Provider<BusinessUnitRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return BusinessUnitRemoteDataSourceImpl(apiClient: apiClient);
});

final businessUnitRepositoryProvider = Provider<BusinessUnitRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(businessUnitRemoteDataSourceProvider);
  return BusinessUnitRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getBusinessUnitsUseCaseProvider = Provider<GetBusinessUnitsUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return GetBusinessUnitsUseCase(repository: repository);
});

final createBusinessUnitUseCaseProvider = Provider<CreateBusinessUnitUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return CreateBusinessUnitUseCase(repository: repository);
});

final updateBusinessUnitUseCaseProvider = Provider<UpdateBusinessUnitUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return UpdateBusinessUnitUseCase(repository: repository);
});

final deleteBusinessUnitUseCaseProvider = Provider<DeleteBusinessUnitUseCase>((ref) {
  final repository = ref.watch(businessUnitRepositoryProvider);
  return DeleteBusinessUnitUseCase(repository: repository);
});

final departmentRemoteDataSourceProvider = Provider<DepartmentRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DepartmentRemoteDataSourceImpl(apiClient: apiClient);
});

final departmentRepositoryProvider = Provider<DepartmentRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(departmentRemoteDataSourceProvider);
  return DepartmentRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getDepartmentsUseCaseProvider = Provider<GetDepartmentsUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return GetDepartmentsUseCase(repository: repository);
});

final createDepartmentUseCaseProvider = Provider<CreateDepartmentUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return CreateDepartmentUseCase(repository: repository);
});

final updateDepartmentUseCaseProvider = Provider<UpdateDepartmentUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return UpdateDepartmentUseCase(repository: repository);
});

final deleteDepartmentUseCaseProvider = Provider<DeleteDepartmentUseCase>((ref) {
  final repository = ref.watch(departmentRepositoryProvider);
  return DeleteDepartmentUseCase(repository: repository);
});

final businessUnitsDropdownProvider =
    StateNotifierProvider.autoDispose<BusinessUnitListNotifier, BusinessUnitListState>((ref) {
      final getBusinessUnitsUseCase = ref.watch(getBusinessUnitsUseCaseProvider);
      return BusinessUnitListNotifier.withPageSize(getBusinessUnitsUseCase: getBusinessUnitsUseCase, pageSize: 1000);
    });

final manageEnterpriseStructureStructureListProvider =
    StateNotifierProvider.autoDispose<StructureListNotifier, StructureListState>((ref) {
      final getStructureListUseCase = ref.watch(getStructureListUseCaseProvider);
      final notifier = StructureListNotifier(
        getStructureListUseCase: getStructureListUseCase,
        enterpriseIdGetter: () => ref.read(manageEnterpriseStructureEnterpriseIdProvider),
      );
      ref.listen(manageEnterpriseStructureEnterpriseIdProvider, (previous, next) {
        if (next != null) notifier.refresh();
      });
      return notifier;
    });

final orgStructuresDropdownProvider = StateNotifierProvider.autoDispose<StructureListNotifier, StructureListState>((
  ref,
) {
  final getStructureListUseCase = ref.watch(getStructureListUseCaseProvider);
  return StructureListNotifier.withPageSize(
    getStructureListUseCase: getStructureListUseCase,
    enterpriseIdGetter: () => ref.read(activeEnterpriseIdProvider),
    pageSize: 1000,
  );
});

final orgStructureLevelRemoteDataSourceProvider = Provider<OrgStructureLevelRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrgStructureLevelRemoteDataSourceImpl(apiClient: apiClient);
});

final orgStructureLevelRepositoryProvider = Provider<OrgStructureLevelRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(orgStructureLevelRemoteDataSourceProvider);
  return OrgStructureLevelRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getActiveLevelsUseCaseProvider = Provider<GetActiveLevelsUseCase>((ref) {
  final repository = ref.watch(orgStructureLevelRepositoryProvider);
  return GetActiveLevelsUseCase(repository: repository);
});

final orgUnitRemoteDataSourceProvider = Provider<OrgUnitRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return OrgUnitRemoteDataSourceImpl(apiClient: apiClient);
});

final orgUnitRepositoryProvider = Provider<OrgUnitRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(orgUnitRemoteDataSourceProvider);
  return OrgUnitRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getOrgUnitsByLevelUseCaseProvider = Provider<GetOrgUnitsByLevelUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return GetOrgUnitsByLevelUseCase(repository: repository);
});

final getOrgUnitsPaginatedUseCaseProvider = Provider<GetOrgUnitsPaginatedUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return GetOrgUnitsPaginatedUseCase(repository: repository);
});

final createOrgUnitUseCaseProvider = Provider<CreateOrgUnitUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return CreateOrgUnitUseCase(repository: repository);
});

final updateOrgUnitUseCaseProvider = Provider<UpdateOrgUnitUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return UpdateOrgUnitUseCase(repository: repository);
});

final deleteOrgUnitUseCaseProvider = Provider<DeleteOrgUnitUseCase>((ref) {
  final repository = ref.watch(orgUnitRepositoryProvider);
  return DeleteOrgUnitUseCase(repository: repository);
});

final structureDeleteRemoteDataSourceProvider = Provider<StructureDeleteRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StructureDeleteRemoteDataSourceImpl(apiClient: apiClient);
});

final structureDeleteRepositoryProvider = Provider<StructureDeleteRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(structureDeleteRemoteDataSourceProvider);
  return StructureDeleteRepositoryImpl(remoteDataSource: remoteDataSource);
});

final deleteStructureUseCaseProvider = Provider<DeleteStructureUseCase>((ref) {
  final repository = ref.watch(structureDeleteRepositoryProvider);
  return DeleteStructureUseCase(repository: repository);
});

final deleteStructureProvider = StateNotifierProvider.autoDispose<DeleteStructureNotifier, DeleteStructureState>((ref) {
  final deleteStructureUseCase = ref.watch(deleteStructureUseCaseProvider);
  return DeleteStructureNotifier(deleteStructureUseCase: deleteStructureUseCase);
});
