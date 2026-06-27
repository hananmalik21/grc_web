import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/components/work_schedules_header_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_content.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_tab_config.dart';
import 'package:flutter/material.dart';

class WorkSchedulesDesktopLayout extends StatelessWidget with WorkSchedulesPermissionMixin {
  const WorkSchedulesDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    required this.onDelete,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;
  final ValueChanged<WorkSchedule> onDelete;

  @override
  Widget build(BuildContext context) {
    return WorkSchedulesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: WorkSchedulesTabConfig.headerTitle,
        description: WorkSchedulesTabConfig.headerDescription,
        trailing: canCreateWorkSchedule ? WorkSchedulesHeaderActions(onCreatePressed: onCreatePressed) : null,
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
