import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/role_delegation_delegations_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/create_role_delegation_dialog.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/role_delegation_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/role_delegation_guidelines_card.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/role_delegation_search_and_filter.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/role_delegation_stats_cards.dart';
import 'package:grc/features/security_manager/presentation/widgets/role_delegation/role_delegation_use_cases_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleDelegationScreen extends ConsumerStatefulWidget {
  const RoleDelegationScreen({super.key});

  @override
  ConsumerState<RoleDelegationScreen> createState() => _RoleDelegationScreenState();
}

class _RoleDelegationScreenState extends ConsumerState<RoleDelegationScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.text = ref.read(roleDelegationProvider).query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDelegationDetails(String delegationId) {
    final delegations = ref.read(roleDelegationProvider).delegations;
    final matches = delegations.where((item) => item.id == delegationId);
    if (matches.isEmpty) return;
    final delegation = matches.first;

    final notifier = ref.read(roleDelegationProvider.notifier);
    RoleDelegationDetailsDialog.show(
      context,
      delegation: delegation,
      onApprove: notifier.approve,
      onRevoke: notifier.revoke,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(roleDelegationProvider);
    final notifier = ref.read(roleDelegationProvider.notifier);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 1100;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20.h,
              children: [
                DigifyTabHeader(
                  title: 'Role Delegation',
                  description: 'Temporary role assignments and authority transfers',
                  trailing: AppButton.primary(
                    label: 'Create Delegation',
                    svgPath: Assets.icons.addNewIconFigma.path,
                    onPressed: () => CreateRoleDelegationDialog.show(context),
                  ),
                ),
                RoleDelegationStatsCards(
                  isDark: isDark,
                  stats: [
                    RoleDelegationStat(
                      title: 'Active',
                      value: notifier.activeCount.toString(),
                      iconPath: Assets.icons.checkIconGreen.path,
                      iconColor: AppColors.success,
                    ),
                    RoleDelegationStat(
                      title: 'Pending Approval',
                      value: notifier.pendingCount.toString(),
                      iconPath: Assets.icons.clockIcon.path,
                      iconColor: AppColors.warning,
                    ),
                    RoleDelegationStat(
                      title: 'Expired',
                      value: notifier.expiredCount.toString(),
                      iconPath: Assets.icons.closeIcon.path,
                      iconColor: AppColors.error,
                    ),
                    RoleDelegationStat(
                      title: 'Total',
                      value: notifier.totalCount.toString(),
                      iconPath: Assets.icons.usersIcon.path,
                      iconColor: AppColors.primary,
                    ),
                  ],
                ),
                RoleDelegationSearchAndFilter(
                  searchController: _searchController,
                  statusFilter: state.statusFilter,
                  onSearchChanged: notifier.setQuery,
                  onStatusFilterChanged: notifier.setStatusFilter,
                  isDark: isDark,
                ),
                RoleDelegationDelegationsSection(
                  isDark: isDark,
                  delegations: notifier.pageDelegations,
                  currentPage: state.currentPage,
                  pageSize: state.pageSize,
                  totalItems: notifier.filteredCount,
                  onApprove: notifier.approve,
                  onRevoke: notifier.revoke,
                  onDetails: _openDelegationDetails,
                  onPrevious: notifier.hasPrevious ? () => notifier.setPage(state.currentPage - 1) : null,
                  onNext: notifier.hasNext ? () => notifier.setPage(state.currentPage + 1) : null,
                ),
                if (isWide)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 20.w,
                    children: [
                      Expanded(child: RoleDelegationGuidelinesCard(isDark: isDark)),
                      Expanded(child: RoleDelegationUseCasesCard(isDark: isDark)),
                    ],
                  )
                else
                  Column(
                    spacing: 20.h,
                    children: [
                      RoleDelegationGuidelinesCard(isDark: isDark),
                      RoleDelegationUseCasesCard(isDark: isDark),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
