import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shifts_header_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_content.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_tab_config.dart';
import 'package:flutter/material.dart';

class ShiftsDesktopLayout extends StatelessWidget with ShiftsPermissionMixin {
  const ShiftsDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    required this.onDelete,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;
  final ValueChanged<ShiftOverview> onDelete;

  @override
  Widget build(BuildContext context) {
    return ShiftsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: ShiftsTabConfig.headerTitle,
        description: ShiftsTabConfig.headerDescription,
        trailing: canCreateShift ? ShiftsHeaderActions(onCreatePressed: onCreatePressed) : null,
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
