import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/presentation/providers/all_leave_balances_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances/all_leave_balances_mobile_filters_bar.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances/all_leave_balances_stats_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances/leave_balances_filters_bar.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances/all_leave_balances_mobile_list.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AllLeaveBalancesContent extends ConsumerStatefulWidget {
  const AllLeaveBalancesContent({
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
  ConsumerState<AllLeaveBalancesContent> createState() => _AllLeaveBalancesContentState();
}

class _AllLeaveBalancesContentState extends ConsumerState<AllLeaveBalancesContent> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onExport() {
    final enterpriseId = ref.read(allLeaveBalancesTabEnterpriseIdProvider);
    final localizations = AppLocalizations.of(context)!;
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.leaveBalances(localizations));
  }

  Widget _buildFiltersBar(BuildContext context, AppLocalizations localizations, bool isExporting) {
    if (context.isMobile) {
      return AllLeaveBalancesMobileFiltersBar(
        searchController: _searchController,
        onSearchChanged: (value) => ref.read(leaveBalanceSummaryListProvider.notifier).setSearchQueryInput(value),
        onSearchSubmitted: (value) => ref.read(leaveBalanceSummaryListProvider.notifier).search(value.trim()),
        onExport: _onExport,
        onRefresh: () => ref.read(leaveBalanceSummaryListProvider.notifier).refresh(),
        isExporting: isExporting,
      );
    }
    return LeaveBalancesFiltersBar(
      localizations: localizations,
      searchController: _searchController,
      onSearchChanged: (value) => ref.read(leaveBalanceSummaryListProvider.notifier).setSearchQueryInput(value),
      onSearchSubmitted: (value) => ref.read(leaveBalanceSummaryListProvider.notifier).search(value.trim()),
      onExport: _onExport,
      onRefresh: () => ref.read(leaveBalanceSummaryListProvider.notifier).refresh(),
      isExporting: isExporting,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isExporting = ref.watch(spreadsheetExportProvider);

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
            const AllLeaveBalancesStatsSection(),
            Gap(widget.sectionSpacing),
            _buildFiltersBar(context, localizations, isExporting),
            const Gap(16),
            if (context.isMobile) const AllLeaveBalancesMobileList() else const LeaveBalancesTable(),
          ],
        ),
      ),
    );
  }
}
