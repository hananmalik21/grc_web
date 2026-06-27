import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/adjust_leave_balance_dialog.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balance_stats_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances/leave_balances_filters_bar.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances/leave_balances_table_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class LeaveBalanceContent extends ConsumerStatefulWidget {
  const LeaveBalanceContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  ConsumerState<LeaveBalanceContent> createState() => _LeaveBalanceContentState();
}

class _LeaveBalanceContentState extends ConsumerState<LeaveBalanceContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onAdjustRequested(BuildContext context, LeaveBalanceSummaryItem item) {
    AdjustLeaveBalanceDialog.show(context, item: item);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.isMobile;
    final effectiveEnterpriseId = ref.watch(leaveBalanceTabEnterpriseIdProvider);
    final listState = ref.watch(leaveBalanceSummaryListProvider);

    final onPreviousPage = listState.pagination?.hasPrevious == true
        ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage - 1)
        : null;
    final onNextPage = listState.pagination?.hasNext == true
        ? () => ref.read(leaveBalanceSummaryListProvider.notifier).goToPage(listState.currentPage + 1)
        : null;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.header,
            Gap(widget.sectionSpacing),
            widget.enterpriseSelector,
            Gap(widget.sectionSpacing),
            const LeaveBalanceStatsSection(),
            Gap(widget.sectionSpacing),
            LeaveBalancesFiltersBar(
              localizations: localizations,
              searchController: _searchController,
              onSearchChanged: (value) =>
                  ref.read(leaveBalanceSummaryListProvider.notifier).setSearchQueryInput(value),
              onSearchSubmitted: (value) =>
                  ref.read(leaveBalanceSummaryListProvider.notifier).search(value.trim()),
              onExport: () {},
              onRefresh: () => ref.read(leaveBalanceSummaryListProvider.notifier).refresh(),
            ),
            const Gap(16),
            if (listState.error != null)
              DigifyErrorState(
                message: localizations.somethingWentWrong,
                retryLabel: localizations.retry,
                onRetry: () => ref.read(leaveBalanceSummaryListProvider.notifier).refresh(),
              )
            else if (effectiveEnterpriseId == null)
              SizedBox(
                height: isMobile ? 260 : 320,
                child: EmptyStateWidget(
                  icon: Icons.business_rounded,
                  title: localizations.selectCompany,
                ),
              )
            else if (listState.items.isEmpty && !listState.isLoading)
              SizedBox(
                height: isMobile ? 260 : 320,
                child: EmptyStateWidget(
                  icon: Icons.calendar_today_rounded,
                  title: localizations.noResultsFound,
                ),
              )
            else ...[
              LeaveBalancesTableSection(
                localizations: localizations,
                items: listState.items,
                isDark: isDark,
                isLoading: listState.isLoading,
                error: listState.error != null ? localizations.somethingWentWrong : null,
                onAdjustRequested: _onAdjustRequested,
              ),
              if (listState.pagination != null) ...[
                const Gap(16),
                PaginationControls.fromPaginationInfo(
                  paginationInfo: listState.pagination!,
                  currentPage: listState.currentPage,
                  pageSize: listState.pagination!.pageSize,
                  onPrevious: onPreviousPage,
                  onNext: onNextPage,
                  isLoading: false,
                  style: PaginationStyle.simple,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
