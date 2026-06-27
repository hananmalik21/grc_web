import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/salary_structure_management/salary_structure_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/salary_structure_management/salary_structure_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_page.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';
import 'package:grc/features/compensation/domain/usecases/salary_structure_management/get_salary_structures_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int createCompensationPlanSalaryStructuresDefaultPage = 1;
const int createCompensationPlanSalaryStructuresDefaultPageSize = 10;

final createCompensationPlanSalaryStructuresCurrentPageProvider = StateProvider<int>(
  (ref) => createCompensationPlanSalaryStructuresDefaultPage,
);

final _createCompensationPlanSalaryStructuresApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _createCompensationPlanSalaryStructuresRemoteDataSourceProvider = Provider<SalaryStructureRemoteDataSource>((
  ref,
) {
  return SalaryStructureRemoteDataSourceImpl(
    apiClient: ref.watch(_createCompensationPlanSalaryStructuresApiClientProvider),
  );
});

final _createCompensationPlanSalaryStructuresRepositoryProvider = Provider<SalaryStructureRepository>((ref) {
  return SalaryStructureRepositoryImpl(
    remoteDataSource: ref.watch(_createCompensationPlanSalaryStructuresRemoteDataSourceProvider),
  );
});

final _createCompensationPlanGetSalaryStructuresUseCaseProvider = Provider<GetSalaryStructuresUseCase>((ref) {
  return GetSalaryStructuresUseCase(repository: ref.watch(_createCompensationPlanSalaryStructuresRepositoryProvider));
});

final createCompensationPlanSalaryStructuresPageProvider = FutureProvider.autoDispose<SalaryStructurePage>((ref) async {
  final enterpriseId = ref.watch(compensationPlansTabEnterpriseIdProvider);
  final currentPage = ref.watch(createCompensationPlanSalaryStructuresCurrentPageProvider);

  if (enterpriseId == null) {
    return const SalaryStructurePage(items: [], pagination: null);
  }

  final useCase = ref.watch(_createCompensationPlanGetSalaryStructuresUseCaseProvider);
  return useCase(
    enterpriseId: enterpriseId,
    page: currentPage,
    pageSize: createCompensationPlanSalaryStructuresDefaultPageSize,
  );
});

final createCompensationPlanSalaryStructuresItemsProvider = Provider.autoDispose<List<SalaryStructureItem>>((ref) {
  final page = ref.watch(createCompensationPlanSalaryStructuresPageProvider).valueOrNull;
  if (page == null) {
    return const [];
  }

  return page.items;
});
