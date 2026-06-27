import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/leave_management/presentation/providers/team_leave_risk_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/team_leave_risk_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_filters_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_stat_cards.dart';
import 'package:grc/features/leave_management/presentation/widgets/team_leave_risk/team_leave_risk_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TeamLeaveRiskTab extends ConsumerStatefulWidget {
  const TeamLeaveRiskTab({super.key});

  @override
  ConsumerState<TeamLeaveRiskTab> createState() => _TeamLeaveRiskTabState();
}

class _TeamLeaveRiskTabState extends ConsumerState<TeamLeaveRiskTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(teamLeaveRiskTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(teamLeaveRiskProvider.notifier).refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(teamLeaveRiskProvider);
    final effectiveEnterpriseId = ref.watch(teamLeaveRiskTabEnterpriseIdProvider);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 21.h,
        children: [
          DigifyTabHeader(
            title: localizations.teamLeaveRiskDashboard,
            description: localizations.monitorAndManageTeamMembersAtRisk,
          ),
          EnterpriseSelectorWidget(
            selectedEnterpriseId: effectiveEnterpriseId,
            onEnterpriseChanged: (enterpriseId) {
              ref.read(teamLeaveRiskTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
            },
          ),
          TeamLeaveRiskStatCards(stats: state.stats, isDark: isDark),
          TeamLeaveRiskFiltersSection(localizations: localizations, isDark: isDark),
          TeamLeaveRiskTable(
            employees: state.employees,
            localizations: localizations,
            isDark: isDark,
            onApprove: (value) {},
            onView: (value) {},
          ),
        ],
      ),
    );
  }
}
