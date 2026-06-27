import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_mobile_content_area.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_screen_state.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employee_management_stats_cards.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employee_search_and_actions_mobile.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ManageEmployeesMobileLayout extends ConsumerWidget {
  const ManageEmployeesMobileLayout({required this.onAddEmployeePressed, required this.onEnterpriseChanged, super.key});

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
        padding: ResponsiveHelper.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyMobileTabHeader(
              title: s.localizations.manageEmployees,
              trailing: AppMobileButton(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onAddEmployeePressed),
            ),
            Gap(sectionSpacing),
            EmployeeManagementStatsCards(localizations: s.localizations, isDark: s.isDark),
            Gap(sectionSpacing),
            EnterpriseSelectorMobileWidget(
              selectedEnterpriseId: s.effectiveEnterpriseId,
              onEnterpriseChanged: onEnterpriseChanged,
            ),
            Gap(sectionSpacing),
            EmployeeSearchAndActionsMobile(localizations: s.localizations, isDark: s.isDark),
            Gap(sectionSpacing),
            ManageEmployeesMobileContentArea(s: s, ref: ref),
          ],
        ),
      ),
    );
  }
}
