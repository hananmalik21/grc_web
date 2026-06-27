import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/compensation/data/datasources/components/comp_components_remote_data_source.dart';
import 'package:grc/features/compensation/data/repositories/components/comp_components_repository_impl.dart';
import 'package:grc/features/compensation/domain/models/components/comp_components_page.dart';
import 'package:grc/features/compensation/domain/models/components/comp_components_pagination.dart';
import 'package:grc/features/compensation/domain/repositories/components/comp_components_repository.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_filter_provider.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_data_table_skeleton.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/component_table_row_data.dart';

const int componentsDefaultPage = 1;
const int componentsDefaultPageSize = 10;

final componentsTabRefreshTickProvider = StateProvider<int>((ref) => 0);
final componentsCurrentPageProvider = StateProvider<int>((ref) => componentsDefaultPage);

final _componentsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _compComponentsRemoteDataSourceProvider = Provider<CompComponentsRemoteDataSource>((ref) {
  return CompComponentsRemoteDataSourceImpl(apiClient: ref.watch(_componentsApiClientProvider));
});

final _compComponentsRepositoryProvider = Provider<CompComponentsRepository>((ref) {
  return CompComponentsRepositoryImpl(remoteDataSource: ref.watch(_compComponentsRemoteDataSourceProvider));
});

final componentsPageProvider = FutureProvider.autoDispose<CompComponentsPage>((ref) async {
  ref.watch(componentsTabRefreshTickProvider);
  final tenantId = ref.watch(componentsTabEnterpriseIdProvider);
  final currentPage = ref.watch(componentsCurrentPageProvider);
  final filters = ref.watch(componentsFilterProvider);

  if (tenantId == null) {
    return const CompComponentsPage(items: [], pagination: null);
  }

  final repository = ref.watch(_compComponentsRepositoryProvider);
  return repository.getComponents(
    tenantId: tenantId,
    page: currentPage,
    pageSize: ComponentsTableConfig.pageSize,
    search: filters.searchQuery.trim().isEmpty ? null : filters.searchQuery.trim(),
    category: filters.category,
    calculationMethod: filters.calculationMethod,
    status: filters.status?.apiValue,
  );
});

final componentsTableRowsProvider = FutureProvider.autoDispose<List<ComponentTableRowData>>((ref) async {
  final page = await ref.watch(componentsPageProvider.future);
  return page.items
      .map(
        (item) => ComponentTableRowData(
          name: item.componentName,
          code: item.componentCode,
          category: item.compCategoryCode,
          calculation: item.calculationMethodCode,
          status: item.status,
          payroll: 'Not Mapped',
          description: item.description,
          usedInPlans: item.planUsageCount,
          component: item,
        ),
      )
      .toList();
});

final componentsPaginationProvider = Provider<CompComponentsPagination?>((ref) {
  return ref.watch(componentsPageProvider).valueOrNull?.pagination;
});

final componentsTotalPagesProvider = Provider<int>((ref) {
  return ref.watch(componentsPaginationProvider)?.totalPages ?? 1;
});

final componentsTotalItemsProvider = Provider<int>((ref) {
  final pagination = ref.watch(componentsPaginationProvider);
  return pagination?.total ?? 0;
});

final componentsHasNextProvider = Provider<bool>((ref) {
  return ref.watch(componentsPaginationProvider)?.hasNext ?? false;
});

final componentsHasPreviousProvider = Provider<bool>((ref) {
  return ref.watch(componentsPaginationProvider)?.hasPrevious ?? false;
});

final componentsTableIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(componentsPageProvider).isLoading;
});

final componentsTableErrorProvider = Provider<String?>((ref) {
  final async = ref.watch(componentsPageProvider);
  return async.hasError ? async.error.toString() : null;
});

final componentsSkeletonRowsProvider = Provider<List<ComponentTableRowData>>((ref) {
  return ComponentsDataTableSkeleton.skeletonRows;
});

final componentsDeletionControllerProvider = NotifierProvider<ComponentsDeletionController, String?>(
  ComponentsDeletionController.new,
);

class ComponentsDeletionController extends Notifier<String?> {
  @override
  String? build() => null;

  Future<void> deleteComponent({required String componentGuid}) async {
    final tenantId = ref.read(componentsTabEnterpriseIdProvider);
    if (tenantId == null) return;

    final repository = ref.read(_compComponentsRepositoryProvider);
    state = componentGuid;
    try {
      await repository.deleteComponent(componentGuid: componentGuid, tenantId: tenantId);
      ref.invalidate(componentsPageProvider);
    } finally {
      state = null;
    }
  }
}
