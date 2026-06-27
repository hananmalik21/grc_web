import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/get_requisition_detail_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/requisition_detail_header.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/requisition_detail_tab_bar.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/requisition_applications_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/requisition_approval_workflow_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/requisition_find_candidates_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/requisition_history_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/requisition_job_posting_tab.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/requisition_overview_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionDetailPage extends ConsumerStatefulWidget {
  const RequisitionDetailPage({super.key, required this.row});

  final RequisitionTableRowData row;

  static const String routeName = 'hiring-requisition-detail';
  static const String path = 'requisition-detail';

  @override
  ConsumerState<RequisitionDetailPage> createState() => _RequisitionDetailPageState();
}

class _RequisitionDetailPageState extends ConsumerState<RequisitionDetailPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  GetRequisitionDetailParams get _detailParams {
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider) ?? 1;
    return GetRequisitionDetailParams(enterpriseId: enterpriseId, requisitionGuid: widget.row.id);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final detailAsync = ref.watch(getRequisitionDetailRowProvider(_detailParams));
    final loc = AppLocalizations.of(context)!;

    ref.listen(getRequisitionDetailRowProvider(_detailParams), (previous, next) {
      if (next is AsyncError && next != previous) {
        ToastService.error(context, next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: detailAsync.when(
        data: (row) => _buildContent(context, row, isDark),
        loading: () => _buildLoading(context, isDark, loc),
        error: (error, _) => _buildError(context, error, loc),
      ),
    );
  }

  Widget _buildLoading(BuildContext context, bool isDark, AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoadingIndicator(
            type: LoadingType.fadingCircle,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            size: 48.r,
          ),
          Gap(16.h),
          Text(
            loc.loading,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, Object error, AppLocalizations loc) {
    return Center(
      child: DigifyErrorState(
        message: error.toString(),
        onRetry: () => ref.invalidate(getRequisitionDetailRowProvider(_detailParams)),
        retryLabel: loc.retry,
      ),
    );
  }

  Widget _buildContent(BuildContext context, RequisitionTableRowData row, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequisitionDetailHeader(row: row, isDark: isDark),
          Gap(24.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RequisitionDetailTabBar(controller: _tabController, isDark: isDark),
              Gap(24.h),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _buildTabContent(_tabController.index, row, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(int index, RequisitionTableRowData row, bool isDark) {
    final child = switch (index) {
      0 => RequisitionOverviewTab(row: row, isDark: isDark),
      1 => RequisitionApprovalWorkflowTab(row: row, isDark: isDark),
      2 => RequisitionJobPostingTab(row: row, isDark: isDark),
      3 => RequisitionApplicationsTab(row: row, isDark: isDark),
      4 => RequisitionFindCandidatesTab(row: row, isDark: isDark),
      5 => RequisitionHistoryTab(row: row, isDark: isDark),
      _ => const SizedBox.shrink(),
    };
    return KeyedSubtree(key: ValueKey<int>(index), child: child);
  }
}
