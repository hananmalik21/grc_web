import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_content.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_tab_config.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class WorkSchedulesMobileLayout extends StatelessWidget with WorkSchedulesPermissionMixin {
  const WorkSchedulesMobileLayout({
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
      header: DigifyMobileTabHeader(
        title: WorkSchedulesTabConfig.headerTitle,
        trailing: canCreateWorkSchedule
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
