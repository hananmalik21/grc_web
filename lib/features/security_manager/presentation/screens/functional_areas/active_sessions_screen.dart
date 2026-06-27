import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:grc/features/security_manager/presentation/providers/active_sessions/active_sessions_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/active_sessions/widgets/active_sessions_header.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_sessions_auto_refresh_banner.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_sessions_distribution_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_sessions_search_and_filter.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_sessions_stats_cards.dart';
import 'package:grc/features/security_manager/presentation/widgets/active_sessions/active_sessions_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionsScreen extends ConsumerStatefulWidget {
  const ActiveSessionsScreen({super.key});

  @override
  ConsumerState<ActiveSessionsScreen> createState() => _ActiveSessionsScreenState();
}

class _ActiveSessionsScreenState extends ConsumerState<ActiveSessionsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.text = ref.read(activeSessionsProvider).query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(activeSessionsProvider);
    final notifier = ref.read(activeSessionsProvider.notifier);
    final effectiveEnterpriseId = ref.watch(securityManagerEnterpriseIdProvider);
    final activeCount = notifier.countByStatus(ActiveSessionStatus.active);
    final idleCount = notifier.countByStatus(ActiveSessionStatus.idle);
    final lockedCount = notifier.countByStatus(ActiveSessionStatus.locked);
    final totalCount = state.sessions.length;
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ActiveSessionsHeader(),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(securityManagerSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
            ),
            Gap(24.h),
            ActiveSessionsStatsCards(
              isDark: isDark,
              activeCount: activeCount,
              idleCount: idleCount,
              lockedCount: lockedCount,
              totalCount: totalCount,
            ),
            Gap(16.h),
            ActiveSessionsSearchAndFilter(
              searchController: _searchController,
              statusFilter: state.statusFilter,
              isDark: isDark,
              onSearchChanged: notifier.setQuery,
              onStatusFilterChanged: notifier.setStatusFilter,
            ),
            Gap(10.h),
            ActiveSessionsAutoRefreshBanner(isDark: isDark),
            Gap(16.h),
            ActiveSessionsTable(
              sessions: notifier.pageItems,
              isDark: isDark,
              currentPage: state.currentPage,
              pageSize: state.pageSize,
              totalItems: notifier.totalItems,
              onPrevious: notifier.hasPrevious ? () => notifier.setPage(state.currentPage - 1) : null,
              onNext: notifier.hasNext ? () => notifier.setPage(state.currentPage + 1) : null,
            ),
            Gap(16.h),
            ActiveSessionsDistributionSection(isDark: isDark, sessions: state.sessions),
          ],
        ),
      ),
    );
  }
}
