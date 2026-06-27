import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_list_item.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_list_page.dart';
import 'package:grc/features/compensation/presentation/providers/employees/employee_compensation_list_usecase_provider.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeCompensationListSearchProvider = StateProvider<String>((ref) => '');
final employeeCompensationListCurrentPageProvider = StateProvider<int>((ref) => 1);
final employeeCompensationListRefreshTickProvider = StateProvider<int>((ref) => 0);

const int _kEmployeeCompensationPageSize = 10;

final employeeCompensationListPageProvider = FutureProvider.autoDispose<EmployeeCompensationListPage>((ref) async {
  ref.watch(employeeCompensationListRefreshTickProvider);

  final enterpriseId = ref.watch(compensationEmployeeTabEnterpriseIdProvider);
  if (enterpriseId == null) {
    return const EmployeeCompensationListPage(
      items: [],
      page: 1,
      pageSize: _kEmployeeCompensationPageSize,
      total: 0,
      totalPages: 1,
      hasNext: false,
      hasPrevious: false,
    );
  }

  final page = ref.watch(employeeCompensationListCurrentPageProvider);
  final search = ref.watch(employeeCompensationListSearchProvider);

  final useCase = ref.watch(getEmployeeCompensationListUseCaseProvider);
  return useCase(
    enterpriseId: enterpriseId,
    page: page,
    pageSize: _kEmployeeCompensationPageSize,
    search: search.trim().isEmpty ? null : search.trim(),
  );
});

final employeeCompensationListItemsProvider = Provider<List<EmployeeCompensationListItem>>((ref) {
  return ref.watch(employeeCompensationListPageProvider).valueOrNull?.items ?? const [];
});

final employeeCompensationListPaginationProvider = Provider<EmployeeCompensationListPage?>((ref) {
  return ref.watch(employeeCompensationListPageProvider).valueOrNull;
});

final employeeCompensationTotalPagesProvider = Provider<int>((ref) {
  return ref.watch(employeeCompensationListPaginationProvider)?.totalPages ?? 1;
});

final employeeCompensationTotalItemsProvider = Provider<int>((ref) {
  final page = ref.watch(employeeCompensationListPaginationProvider);
  return page?.total ?? ref.watch(employeeCompensationListItemsProvider).length;
});

final employeeCompensationHasNextProvider = Provider<bool>((ref) {
  return ref.watch(employeeCompensationListPaginationProvider)?.hasNext ?? false;
});

final employeeCompensationHasPreviousProvider = Provider<bool>((ref) {
  return ref.watch(employeeCompensationListPaginationProvider)?.hasPrevious ?? false;
});

final employeeCompensationIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(employeeCompensationListPageProvider).isLoading;
});

final employeeCompensationErrorProvider = Provider<String?>((ref) {
  final async = ref.watch(employeeCompensationListPageProvider);
  return async.hasError ? async.error.toString() : null;
});

class EmployeeCompensationListActionsNotifier extends AutoDisposeNotifier<void> {
  Debouncer? _debouncer;

  @override
  void build() {}

  void loadInitial() {
    final enterpriseId = ref.read(compensationEmployeeTabEnterpriseIdProvider);
    if (enterpriseId == null) return;
    ref.read(employeeCompensationListCurrentPageProvider.notifier).state = 1;
    ref.invalidate(employeeCompensationListPageProvider);
  }

  void nextPage() {
    final hasNext = ref.read(employeeCompensationHasNextProvider);
    if (!hasNext) return;
    final current = ref.read(employeeCompensationListCurrentPageProvider);
    ref.read(employeeCompensationListCurrentPageProvider.notifier).state = current + 1;
  }

  void previousPage() {
    final current = ref.read(employeeCompensationListCurrentPageProvider);
    if (current <= 1) return;
    ref.read(employeeCompensationListCurrentPageProvider.notifier).state = current - 1;
  }

  void refresh() {
    ref.read(employeeCompensationListRefreshTickProvider.notifier).state++;
  }

  void updateSearch(String query) {
    final debouncer = _debouncer ??= Debouncer(delay: const Duration(milliseconds: 500));
    debouncer.run(() {
      ref.read(employeeCompensationListSearchProvider.notifier).state = query;
      ref.read(employeeCompensationListCurrentPageProvider.notifier).state = 1;
      ref.invalidate(employeeCompensationListPageProvider);
    });
  }

  void onDispose() {
    _debouncer?.dispose();
  }
}

final employeeCompensationListActionsProvider =
    AutoDisposeNotifierProvider<EmployeeCompensationListActionsNotifier, void>(
      EmployeeCompensationListActionsNotifier.new,
    );
