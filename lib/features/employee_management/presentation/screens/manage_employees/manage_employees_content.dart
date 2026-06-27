import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_content_area.dart';
import 'package:grc/features/employee_management/presentation/screens/mixins/manage_employees_permission_mixin.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_screen_state.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employee_management_stats_cards.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employee_search_and_actions.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ManageEmployeesContent extends ConsumerWidget with ManageEmployeesPermissionMixin {
  const ManageEmployeesContent({
    required this.padding,
    required this.onAddEmployeePressed,
    required this.onEnterpriseChanged,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final VoidCallback onAddEmployeePressed;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = readManageEmployeesState(context, ref);
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Container(
      color: s.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: s.localizations.manageEmployees,
              description: s.localizations.manageEmployeesDescription,
              trailing: canCreateEmployee
                  ? AppButton.primary(
                      label: s.localizations.addNewEmployee,
                      svgPath: Assets.icons.addDivisionIcon.path,
                      onPressed: onAddEmployeePressed,
                    )
                  : null,
            ),
            Gap(sectionSpacing),
            EmployeeManagementStatsCards(localizations: s.localizations, isDark: s.isDark),
            Gap(sectionSpacing),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: s.effectiveEnterpriseId,
              onEnterpriseChanged: onEnterpriseChanged,
            ),
            Gap(sectionSpacing),
            EmployeeSearchAndActions(localizations: s.localizations, isDark: s.isDark),
            Gap(sectionSpacing),
            ManageEmployeesContentArea(s: s, ref: ref, forceGrid: false),
          ],
        ),
      ),
    );
  }
}
