import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';

import '../../../data/datasources/compensation_plans/compensation_plans_remote_data_source.dart';
import '../../../data/repositories/compensation_plans/compensation_plans_repository_impl.dart';
import '../../../domain/models/compensation_plans/compensation_plan.dart';
import '../../../domain/models/compensation_plans/compensation_plans_page.dart';
import '../../../domain/models/compensation_plans/compensation_plans_pagination.dart';
import '../../../domain/repositories/compensation_plans/compensation_plans_repository.dart';
import '../../../domain/usecases/compensation_plans/get_compensation_plans_usecase.dart';
import '../../../domain/usecases/compensation_plans/delete_compensation_plan_usecase.dart';
import '../lookups/comp_lookups_provider.dart';
import '../../models/compensation_plan_table_row_data.dart';
import 'compensation_plans_tab_enterprise_provider.dart';
import '../../widgets/compensation_plans/compensation_plans_table_config.dart';

const int compensationPlansDefaultPage = 1;

final compensationPlansCurrentPageProvider = StateProvider<int>((ref) => 1);
final compensationPlansSearchFilterProvider = StateProvider<String>((ref) => '');
final compensationPlansPlanTypeCodeFilterProvider = StateProvider<String?>((ref) => null);
final compensationPlansCurrencyCodeFilterProvider = StateProvider<String?>((ref) => null);
final compensationPlansStatusFilterProvider = StateProvider<SalaryStructureStatus?>((ref) => null);

class CompensationPlansFilterOption {
  final String code;
  final String label;

  const CompensationPlansFilterOption({required this.code, required this.label});
}

List<CompensationPlansFilterOption> _buildLookupFilterOptions({
  required List<CompLookupValue> values,
  required String allCode,
  required String allLabel,
}) {
  return [
    CompensationPlansFilterOption(code: allCode, label: allLabel),
    ...values.map((value) => CompensationPlansFilterOption(code: value.valueCode, label: value.valueName)),
  ];
}

const compensationPlansAllPlanTypesCode = '__ALL_TYPES__';
const compensationPlansAllCurrencyCode = '__ALL_CURRENCY__';

final compensationPlansPlanTypeFilterOptionsProvider = Provider<List<CompensationPlansFilterOption>>((ref) {
  final values = ref.watch(compensationPlansLookupValuesProvider('PLAN_TYPE')).valueOrNull ?? const <CompLookupValue>[];
  return _buildLookupFilterOptions(values: values, allCode: compensationPlansAllPlanTypesCode, allLabel: 'All Types');
});

final compensationPlansCurrencyFilterOptionsProvider = Provider<List<CompensationPlansFilterOption>>((ref) {
  final values = ref.watch(compensationPlansLookupValuesProvider('CURRENCY')).valueOrNull ?? const <CompLookupValue>[];
  return _buildLookupFilterOptions(values: values, allCode: compensationPlansAllCurrencyCode, allLabel: 'All Currency');
});

final compensationPlansFiltersControllerProvider = NotifierProvider<CompensationPlansFiltersController, void>(
  CompensationPlansFiltersController.new,
);

final compensationPlansDeletionControllerProvider = NotifierProvider<CompensationPlansDeletionController, String?>(
  CompensationPlansDeletionController.new,
);

class CompensationPlansFiltersController extends Notifier<void> {
  static const Duration _searchDebounceDuration = Duration(milliseconds: 500);
  late final Debouncer _searchDebouncer;

  @override
  void build() {
    _searchDebouncer = Debouncer(delay: _searchDebounceDuration);
    ref.onDispose(_searchDebouncer.dispose);
  }

  void onSearchChanged(String value) {
    _searchDebouncer.run(() {
      ref.read(compensationPlansCurrentPageProvider.notifier).state = 1;
      ref.read(compensationPlansSearchFilterProvider.notifier).state = value;
    });
  }

  void onStatusChanged(SalaryStructureStatus? status) {
    ref.read(compensationPlansCurrentPageProvider.notifier).state = 1;
    ref.read(compensationPlansStatusFilterProvider.notifier).state = status;
  }

  void onPlanTypeCodeChanged(String? planTypeCode) {
    ref.read(compensationPlansCurrentPageProvider.notifier).state = 1;
    ref.read(compensationPlansPlanTypeCodeFilterProvider.notifier).state = planTypeCode;
  }

  void onCurrencyCodeChanged(String? currencyCode) {
    ref.read(compensationPlansCurrentPageProvider.notifier).state = 1;
    ref.read(compensationPlansCurrencyCodeFilterProvider.notifier).state = currencyCode;
  }
}

final _compensationPlansApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _compensationPlansRemoteDataSourceProvider = Provider<CompensationPlansRemoteDataSource>((ref) {
  return CompensationPlansRemoteDataSourceImpl(apiClient: ref.watch(_compensationPlansApiClientProvider));
});

final _compensationPlansRepositoryProvider = Provider<CompensationPlansRepository>((ref) {
  return CompensationPlansRepositoryImpl(remoteDataSource: ref.watch(_compensationPlansRemoteDataSourceProvider));
});

final _getCompensationPlansUseCaseProvider = Provider<GetCompensationPlansUseCase>((ref) {
  return GetCompensationPlansUseCase(repository: ref.watch(_compensationPlansRepositoryProvider));
});

final _deleteCompensationPlanUseCaseProvider = Provider<DeleteCompensationPlanUseCase>((ref) {
  return DeleteCompensationPlanUseCase(repository: ref.watch(_compensationPlansRepositoryProvider));
});

final compensationPlansPageProvider = FutureProvider.autoDispose<CompensationPlansPage>((ref) async {
  final enterpriseId = ref.watch(compensationPlansTabEnterpriseIdProvider);
  final currentPage = ref.watch(compensationPlansCurrentPageProvider);
  final search = ref.watch(compensationPlansSearchFilterProvider);
  final planTypeCode = ref.watch(compensationPlansPlanTypeCodeFilterProvider);
  final currencyCode = ref.watch(compensationPlansCurrencyCodeFilterProvider);
  final status = ref.watch(compensationPlansStatusFilterProvider);

  if (enterpriseId == null) {
    return const CompensationPlansPage(items: [], pagination: null);
  }

  final useCase = ref.watch(_getCompensationPlansUseCaseProvider);
  return useCase(
    enterpriseId: enterpriseId,
    page: currentPage,
    limit: CompensationPlansTableConfig.pageSize,
    search: search,
    planTypeCode: planTypeCode,
    currencyCode: currencyCode,
    statusCode: status?.apiValue,
  );
});

final compensationPlansTableRowsProvider = Provider<List<CompensationPlanTableRowData>>((ref) {
  final plans = ref.watch(compensationPlansPageProvider).valueOrNull?.items ?? const <CompensationPlan>[];
  return plans.map(_mapPlanToRow).toList();
});

final compensationPlansPagedRowsProvider = Provider<List<CompensationPlanTableRowData>>((ref) {
  return ref.watch(compensationPlansTableRowsProvider);
});

final compensationPlansPaginationProvider = Provider<CompensationPlansPagination?>((ref) {
  return ref.watch(compensationPlansPageProvider).valueOrNull?.pagination;
});

final compensationPlansTotalPagesProvider = Provider<int>((ref) {
  final pagination = ref.watch(compensationPlansPaginationProvider);
  return pagination?.totalPages ?? 1;
});

final compensationPlansTotalItemsProvider = Provider<int>((ref) {
  final pagination = ref.watch(compensationPlansPaginationProvider);
  return pagination?.total ?? ref.watch(compensationPlansTableRowsProvider).length;
});

final compensationPlansHasNextProvider = Provider<bool>((ref) {
  final pagination = ref.watch(compensationPlansPaginationProvider);
  return pagination?.hasNext ?? false;
});

final compensationPlansHasPreviousProvider = Provider<bool>((ref) {
  final pagination = ref.watch(compensationPlansPaginationProvider);
  return pagination?.hasPrevious ?? false;
});

final compensationPlansTableIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(compensationPlansPageProvider).isLoading;
});

final compensationPlansTableErrorProvider = Provider<String?>((ref) {
  final asyncPage = ref.watch(compensationPlansPageProvider);
  return asyncPage.hasError ? asyncPage.error.toString() : null;
});

final compensationPlansSkeletonRowsProvider = Provider<List<CompensationPlanTableRowData>>((ref) {
  return List.generate(
    CompensationPlansTableConfig.pageSize,
    (index) => CompensationPlanTableRowData(
      name: index % 2 == 0 ? 'Enterprise Annual Merit Plan' : 'Senior Executive Bonus Plan',
      code: 'CMP-${2000 + index}',
      type: index % 3 == 0 ? 'Merit' : (index % 3 == 1 ? 'Bonus' : 'Incentive'),
      status: 'ACTIVE',
      currency: 'KWD',
      planGuid: 'skeleton-plan-$index',
    ),
  );
});

class CompensationPlansDeletionController extends Notifier<String?> {
  @override
  String? build() => null;

  Future<void> deleteCompensationPlan({required String planGuid}) async {
    final useCase = ref.read(_deleteCompensationPlanUseCaseProvider);

    state = planGuid;

    try {
      await useCase(planGuid: planGuid);
      ref.invalidate(compensationPlansPageProvider);
    } finally {
      state = null;
    }
  }
}

CompensationPlanTableRowData _mapPlanToRow(CompensationPlan plan) {
  return CompensationPlanTableRowData(
    name: plan.planName,
    code: plan.planCode,
    type: plan.planTypeCode,
    status: plan.statusCode,
    currency: plan.currencyCode,
    planGuid: plan.planGuid,
  );
}
