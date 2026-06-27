import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_desktop_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_mobile_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkPatternsTab extends ConsumerStatefulWidget {
  const WorkPatternsTab({super.key});

  @override
  ConsumerState<WorkPatternsTab> createState() => _WorkPatternsTabState();
}

class _WorkPatternsTabState extends ConsumerState<WorkPatternsTab> with WorkPatternsPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(workPatternsTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(workPatternsNotifierProvider(enterpriseId).notifier).refresh();
        ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(workPatternsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onCreatePressed() {
    final enterpriseId = ref.read(workPatternsTabEnterpriseIdProvider);
    if (enterpriseId == null) return;
    CreateWorkPatternDialog.show(context, enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewWorkPattern) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(workPatternsTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return WorkPatternsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }
    if (layout.isTablet) {
      return WorkPatternsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }

    return WorkPatternsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
    );
  }
}
