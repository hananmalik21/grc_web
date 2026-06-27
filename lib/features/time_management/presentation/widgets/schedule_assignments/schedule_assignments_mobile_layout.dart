import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_content.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_tab_config.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ScheduleAssignmentsMobileLayout extends StatelessWidget with ScheduleAssignmentsPermissionMixin {
  const ScheduleAssignmentsMobileLayout({
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
      header: DigifyMobileTabHeader(
        title: ScheduleAssignmentsTabConfig.headerTitle,
        trailing: canCreateScheduleAssignment
            ? AppMobileButton.primary(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onCreatePressed)
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      enterpriseId: selectedEnterpriseId,
      onDelete: onDelete,
    );
  }
}
