import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/salary_structure_management/salary_structure_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/salary_structure_management/salary_structure_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_page.dart';
import 'package:grc/features/compensation/domain/repositories/salary_structure_management/salary_structure_repository.dart';
import 'package:grc/features/compensation/domain/usecases/salary_structure_management/get_salary_structures_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_filter_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int salaryStructuresDefaultPage = 1;
const int salaryStructuresDefaultPageSize = 10;

final salaryStructuresRefreshTickProvider = StateProvider<int>((ref) => 0);
final salaryStructuresCurrentPageProvider = StateProvider<int>((ref) => salaryStructuresDefaultPage);
final salaryStructureDeletingGuidProvider = StateProvider<String?>((ref) => null);

final _salaryStructuresApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _salaryStructuresRemoteDataSourceProvider = Provider<SalaryStructureRemoteDataSource>((ref) {
  return SalaryStructureRemoteDataSourceImpl(apiClient: ref.watch(_salaryStructuresApiClientProvider));
});

final _salaryStructuresRepositoryProvider = Provider<SalaryStructureRepository>((ref) {
  return SalaryStructureRepositoryImpl(remoteDataSource: ref.watch(_salaryStructuresRemoteDataSourceProvider));
});

final _getSalaryStructuresUseCaseProvider = Provider<GetSalaryStructuresUseCase>((ref) {
  return GetSalaryStructuresUseCase(repository: ref.watch(_salaryStructuresRepositoryProvider));
});

final salaryStructuresPageProvider = FutureProvider.autoDispose<SalaryStructurePage>((ref) async {
  ref.watch(salaryStructuresRefreshTickProvider);

  final enterpriseId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
  final currentPage = ref.watch(salaryStructuresCurrentPageProvider);
  final filters = ref.watch(salaryStructureFilterProvider);

  // Reset to page 1 whenever filters change.
  ref.listen(salaryStructureFilterProvider, (_, _) {
    ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
  });

  if (enterpriseId == null) {
    return const SalaryStructurePage(items: [], pagination: null);
  }

  final useCase = ref.watch(_getSalaryStructuresUseCaseProvider);
  return useCase(
    enterpriseId: enterpriseId,
    page: currentPage,
    pageSize: salaryStructuresDefaultPageSize,
    search: filters.searchQuery.trim().isEmpty ? null : filters.searchQuery.trim(),
    status: filters.status?.apiValue,
  );
});

final salaryStructuresItemsProvider = Provider.autoDispose<List<SalaryStructureItem>>((ref) {
  final page = ref.watch(salaryStructuresPageProvider).valueOrNull;
  if (page == null) {
    return const [];
  }

  return page.items;
});

final salaryStructureRepositoryProvider = Provider<SalaryStructureRepository>((ref) {
  return ref.watch(_salaryStructuresRepositoryProvider);
});
