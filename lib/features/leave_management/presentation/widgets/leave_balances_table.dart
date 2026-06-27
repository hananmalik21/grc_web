import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/adjust_leave_balance_dialog.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances/leave_balances_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LeaveBalancesTable extends ConsumerStatefulWidget {
  const LeaveBalancesTable({super.key});

  @override
  ConsumerState<LeaveBalancesTable> createState() => _LeaveBalancesTableState();
}

class _LeaveBalancesTableState extends ConsumerState<LeaveBalancesTable> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoadPage());
  }

  void _maybeLoadPage() {
    final enterpriseId = ref.read(leaveManagementEnterpriseIdProvider);
    final state = ref.read(leaveBalanceSummaryListProvider);
    if (enterpriseId != null && state.items.isEmpty && !state.isLoading && state.error == null) {
      ref.read(leaveBalanceSummaryListProvider.notifier).loadPage(enterpriseId, 1);
    }
  }

  void _onAdjustRequested(BuildContext context, LeaveBalanceSummaryItem item) {
    AdjustLeaveBalanceDialog.show(context, item: item);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final listState = ref.watch(leaveBalanceSummaryListProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveBalancesTableSection(
            localizations: localizations,
            items: listState.items,
            isDark: isDark,
            isLoading: listState.isLoading,
            error: listState.error != null ? localizations.somethingWentWrong : null,
            onAdjustRequested: _onAdjustRequested,
          ),
          if (listState.pagination != null)
            PaginationControls.fromPaginationInfo(
              paginationInfo: listState.pagination!,
              currentPage: listState.currentPage,
              pageSize: listState.pagination!.pageSize,
              onPrevious: listState.pagination!.hasPrevious
                  ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage - 1)
                  : null,
              onNext: listState.pagination!.hasNext
                  ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage + 1)
                  : null,
              isLoading: false,
              style: PaginationStyle.simple,
            ),
        ],
      ),
    );
  }
}
