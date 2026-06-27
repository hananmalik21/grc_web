import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_desktop_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_tab_logic_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_mobile_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleAssignmentsTab extends ConsumerStatefulWidget {
  const ScheduleAssignmentsTab({super.key});

  @override
  ConsumerState<ScheduleAssignmentsTab> createState() => _ScheduleAssignmentsTabState();
}

class _ScheduleAssignmentsTabState extends ConsumerState<ScheduleAssignmentsTab>
    with ScheduleAssignmentsPermissionMixin, ScheduleAssignmentsTabLogicMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reloadAssignmentsAndStats(enterpriseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewScheduleAssignment) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(scheduleAssignmentsTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return ScheduleAssignmentsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
        onCreatePressed: () => onCreatePressed(context),
        onDelete: (assignment) => onDelete(context, assignment),
      );
    }
    if (layout.isTablet) {
      return ScheduleAssignmentsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
        onCreatePressed: () => onCreatePressed(context),
        onDelete: (assignment) => onDelete(context, assignment),
      );
    }

    return ScheduleAssignmentsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: onEnterpriseChanged,
      onCreatePressed: () => onCreatePressed(context),
      onDelete: (assignment) => onDelete(context, assignment),
    );
  }
}
