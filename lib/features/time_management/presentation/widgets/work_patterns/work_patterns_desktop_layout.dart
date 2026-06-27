import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_patterns_header_actions.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_content.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_tab_config.dart';
import 'package:flutter/material.dart';

class WorkPatternsDesktopLayout extends StatelessWidget with WorkPatternsPermissionMixin {
  const WorkPatternsDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return WorkPatternsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: WorkPatternsTabConfig.headerTitle,
        description: WorkPatternsTabConfig.headerDescription,
        trailing: canCreateWorkPattern ? WorkPatternsHeaderActions(onCreatePressed: onCreatePressed) : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      enterpriseId: selectedEnterpriseId,
    );
  }
}
