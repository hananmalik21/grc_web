import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/employees/compensation_employees_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/employees/employees_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_list_item.dart';
import 'package:grc/features/compensation/domain/models/employees/employees_page.dart';
import 'package:grc/features/compensation/domain/models/employees/employees_pagination.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employees_repository.dart';
import 'package:grc/features/compensation/domain/usecases/employees/get_employees_usecase.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _compensationEmployeesApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _compensationEmployeesRemoteDataSourceProvider = Provider<CompensationEmployeesRemoteDataSource>((ref) {
  return CompensationEmployeesRemoteDataSourceImpl(apiClient: ref.watch(_compensationEmployeesApiClientProvider));
});

final _compensationEmployeesRepositoryProvider = Provider<EmployeesRepository>((ref) {
  return EmployeesRepositoryImpl(remoteDataSource: ref.watch(_compensationEmployeesRemoteDataSourceProvider));
});

final _getEmployeesUseCaseProvider = Provider<GetEmployeesUseCase>((ref) {
  return GetEmployeesUseCase(repository: ref.watch(_compensationEmployeesRepositoryProvider));
});

final compensationEmployeesCurrentPageProvider = StateProvider<int>((ref) => 1);
final compensationEmployeesSearchProvider = StateProvider<String>((ref) => '');
final compensationEmployeesRefreshTickProvider = StateProvider<int>((ref) => 0);

const int _kCompensationEmployeesPageSize = 10;

final compensationEmployeesPageProvider = FutureProvider.autoDispose<EmployeesPage>((ref) async {
  ref.watch(compensationEmployeesRefreshTickProvider);

  final enterpriseId = ref.watch(compensationEmployeeTabEnterpriseIdProvider);
  final page = ref.watch(compensationEmployeesCurrentPageProvider);
  final search = ref.watch(compensationEmployeesSearchProvider);

  if (enterpriseId == null) {
    return const EmployeesPage(items: [], pagination: null);
  }

  final useCase = ref.watch(_getEmployeesUseCaseProvider);
  return useCase(
    enterpriseId: enterpriseId,
    page: page,
    pageSize: _kCompensationEmployeesPageSize,
    search: search.trim().isEmpty ? null : search.trim(),
  );
});

final compensationEmployeesItemsProvider = Provider<List<EmployeeListItem>>((ref) {
  return ref.watch(compensationEmployeesPageProvider).valueOrNull?.items ?? const [];
});

final compensationEmployeesPaginationProvider = Provider<EmployeesPagination?>((ref) {
  return ref.watch(compensationEmployeesPageProvider).valueOrNull?.pagination;
});

final compensationEmployeesTotalPagesProvider = Provider<int>((ref) {
  return ref.watch(compensationEmployeesPaginationProvider)?.totalPages ?? 1;
});

final compensationEmployeesTotalItemsProvider = Provider<int>((ref) {
  final pagination = ref.watch(compensationEmployeesPaginationProvider);
  return pagination?.total ?? ref.watch(compensationEmployeesItemsProvider).length;
});

final compensationEmployeesHasNextProvider = Provider<bool>((ref) {
  return ref.watch(compensationEmployeesPaginationProvider)?.hasNext ?? false;
});

final compensationEmployeesHasPreviousProvider = Provider<bool>((ref) {
  return ref.watch(compensationEmployeesPaginationProvider)?.hasPrevious ?? false;
});

final compensationEmployeesIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(compensationEmployeesPageProvider).isLoading;
});

final compensationEmployeesErrorProvider = Provider<String?>((ref) {
  final async = ref.watch(compensationEmployeesPageProvider);
  return async.hasError ? async.error.toString() : null;
});

class CompensationEmployeesActionsNotifier extends Notifier<void> {
  @override
  void build() {}

  void loadInitial() {
    final enterpriseId = ref.read(compensationEmployeeTabEnterpriseIdProvider);
    if (enterpriseId == null) return;
    ref.read(compensationEmployeesCurrentPageProvider.notifier).state = 1;
    ref.invalidate(compensationEmployeesPageProvider);
  }

  void nextPage() {
    final current = ref.read(compensationEmployeesCurrentPageProvider);
    final hasNext = ref.read(compensationEmployeesHasNextProvider);
    if (hasNext) {
      ref.read(compensationEmployeesCurrentPageProvider.notifier).state = current + 1;
    }
  }

  void previousPage() {
    final current = ref.read(compensationEmployeesCurrentPageProvider);
    if (current > 1) {
      ref.read(compensationEmployeesCurrentPageProvider.notifier).state = current - 1;
    }
  }

  void updateSearch(String query) {
    ref.read(compensationEmployeesSearchProvider.notifier).state = query;
    ref.read(compensationEmployeesCurrentPageProvider.notifier).state = 1;
  }

  void refresh() {
    ref.read(compensationEmployeesRefreshTickProvider.notifier).state++;
  }
}

final compensationEmployeesActionsProvider = NotifierProvider<CompensationEmployeesActionsNotifier, void>(
  CompensationEmployeesActionsNotifier.new,
);
