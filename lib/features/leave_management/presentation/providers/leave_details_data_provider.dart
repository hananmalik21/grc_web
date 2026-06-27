import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/features/leave_management/data/datasources/leave_balance_transactions_remote_data_source.dart';
import 'package:grc/features/leave_management/data/datasources/leave_details_data_source.dart';
import 'package:grc/features/leave_management/data/dto/leave_details_dto.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_transaction_display.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_types_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_transaction_table_config.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _leaveDetailsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final leaveDetailsDataSourceProvider = Provider<LeaveDetailsDataSource>((ref) {
  return LeaveDetailsDataSourceImpl();
});

final leaveBalanceTransactionsDataSourceProvider = Provider<LeaveBalanceTransactionsRemoteDataSource>((ref) {
  final apiClient = ref.watch(_leaveDetailsApiClientProvider);
  return LeaveBalanceTransactionsRemoteDataSourceImpl(apiClient: apiClient);
});

final leaveDetailsDataProvider = FutureProvider.autoDispose.family<LeaveDetailsData, String>((ref, employeeId) {
  return ref.read(leaveDetailsDataSourceProvider).getLeaveDetails(employeeId);
});

final leaveDetailsTransactionsPaginationProvider = StateProvider.autoDispose.family<(int page, int pageSize), String>((
  ref,
  employeeId,
) {
  return (1, LeaveDetailsTransactionTableConfig.defaultPageSize);
});

final leaveDetailsSelectedLeaveTypeIdProvider = StateProvider.autoDispose.family<int?, String>(
  (ref, employeeId) => null,
);

final leaveDetailsEffectiveLeaveTypeIdProvider = Provider.autoDispose.family<int?, String>((ref, employeeGuid) {
  final selectedId = ref.watch(leaveDetailsSelectedLeaveTypeIdProvider(employeeGuid));
  final leaveTypesState = ref.watch(leaveTypesNotifierProvider);
  final leaveTypes = leaveTypesState.leaveTypes;
  return selectedId ?? leaveTypes.firstOrNull?.id;
});

class LeaveDetailsTransactionPageState {
  const LeaveDetailsTransactionPageState({
    required this.transactions,
    this.paginationInfo,
    required this.currentPage,
    required this.pageSize,
    this.moveNext,
    this.movePrevious,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<LeaveBalanceTransactionDisplay> transactions;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final void Function()? moveNext;
  final void Function()? movePrevious;
  final bool isLoading;
  final String? errorMessage;

  static LeaveDetailsTransactionPageState empty() {
    return const LeaveDetailsTransactionPageState(
      transactions: [],
      currentPage: 1,
      pageSize: LeaveDetailsTransactionTableConfig.defaultPageSize,
    );
  }
}

final leaveDetailsTransactionsResultProvider = FutureProvider.autoDispose
    .family<LeaveBalanceTransactionsResult, String>((ref, employeeGuid) async {
      final leaveTypeId = ref.watch(leaveDetailsEffectiveLeaveTypeIdProvider(employeeGuid));
      final enterpriseId = ref.watch(leaveManagementEnterpriseIdProvider);
      final pagination = ref.watch(leaveDetailsTransactionsPaginationProvider(employeeGuid));
      final page = pagination.$1;
      final pageSize = pagination.$2;

      if (leaveTypeId == null || enterpriseId == null) {
        return LeaveBalanceTransactionsResult(
          transactions: const [],
          pagination: PaginationInfo(
            currentPage: page,
            totalPages: 1,
            totalItems: 0,
            pageSize: pageSize,
            hasNext: false,
            hasPrevious: false,
          ),
        );
      }

      final dataSource = ref.read(leaveBalanceTransactionsDataSourceProvider);
      final dto = await dataSource.getTransactions(
        employeeGuid: employeeGuid,
        leaveTypeId: leaveTypeId,
        enterpriseId: enterpriseId,
        page: page,
        pageSize: pageSize,
        tenantId: enterpriseId,
      );
      return dto.toDomain();
    });

final leaveDetailsTransactionPageProvider = Provider.autoDispose.family<LeaveDetailsTransactionPageState, String>((
  ref,
  employeeGuid,
) {
  final asyncResult = ref.watch(leaveDetailsTransactionsResultProvider(employeeGuid));
  final pagination = ref.watch(leaveDetailsTransactionsPaginationProvider(employeeGuid));
  final paginationNotifier = ref.read(leaveDetailsTransactionsPaginationProvider(employeeGuid).notifier);
  final page = pagination.$1;
  final pageSize = pagination.$2;

  return asyncResult.when(
    loading: () => LeaveDetailsTransactionPageState(
      transactions: const [],
      currentPage: page,
      pageSize: pageSize,
      isLoading: true,
    ),
    error: (e, _) => LeaveDetailsTransactionPageState(
      transactions: const [],
      currentPage: page,
      pageSize: pageSize,
      errorMessage: e.toString(),
    ),
    data: (result) {
      final paginationInfo = result.pagination;
      return LeaveDetailsTransactionPageState(
        transactions: result.transactions,
        paginationInfo: paginationInfo,
        currentPage: page,
        pageSize: pageSize,
        moveNext: paginationInfo.hasNext ? () => paginationNotifier.state = (page + 1, pageSize) : null,
        movePrevious: paginationInfo.hasPrevious ? () => paginationNotifier.state = (page - 1, pageSize) : null,
      );
    },
  );
});
