import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/components/schedule_assignments_header_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_content.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_tab_config.dart';
import 'package:flutter/material.dart';

class ScheduleAssignmentsDesktopLayout extends StatelessWidget with ScheduleAssignmentsPermissionMixin {
  const ScheduleAssignmentsDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    required this.onDelete,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;
  final ValueChanged<ScheduleAssignment> onDelete;

  @override
  Widget build(BuildContext context) {
    return ScheduleAssignmentsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: ScheduleAssignmentsTabConfig.headerTitle,
        description: ScheduleAssignmentsTabConfig.headerDescription,
        trailing: canCreateScheduleAssignment
            ? ScheduleAssignmentsHeaderActions(onCreatePressed: onCreatePressed)
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      enterpriseId: selectedEnterpriseId,
      onDelete: onDelete,
    );
  }
}
