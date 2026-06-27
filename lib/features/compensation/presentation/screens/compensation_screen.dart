import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/responsive_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/breadcrumb_nav_extra.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/digify_breadcrumb.dart';
import '../providers/compensation_tab_state_provider.dart';
import 'adjustments/adjustments_tab.dart';
import 'allowances_and_benefits_tab.dart';
import 'bonuses_and_incentives_tab.dart';
import 'bulk_adjustments/bulk_adjustments_tab.dart';
import 'compensation_plans_tab/compensation_plans_tab.dart';
import 'compensation_simulation_tab.dart';
import 'components_tab/components_tab.dart';
import 'employee_compensation/employee_compensation_tab.dart';
import 'grade_structure_management_screen.dart';
import 'localization_tab/localization_tab.dart';
import 'manage_salary_structure_tab/manage_salary_structure_tab.dart';
import 'merit_planning_tab.dart';
import 'revision_history_tab.dart';
import 'salary_change_history_tab.dart';
import 'setup_and_configuration_tab.dart';

class CompensationScreen extends ConsumerWidget {
  const CompensationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(compensationTabStateProvider.select((s) => s.currentTabIndex));
    final isMobile = ResponsiveHelper.isMobile(context);
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('compensation');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTabIndex(currentTabIndex);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getPagePadding(context),
            child: isMobile
                ? null
                : DigifyBreadcrumb(
                    items: [
                      DigifyBreadcrumbItem(label: 'Dashboard', onTap: () => context.go(AppRoutes.dashboard)),
                      const DigifyBreadcrumbItem(label: 'Compensation'),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(context, currentTabIndex)),
        ],
      ),
    );
  }

  String _childLabelForTabIndex(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Grade Structure';
      case 1:
        return 'Setup & Configuration';
      case 2:
        return 'Localization';
      case 3:
        return 'Components';
      case 4:
        return 'Manage Salary Structure';
      case 5:
        return 'Compensation Plans';
      case 6:
        return 'Compensation Simulation';
      case 7:
        return 'Employee Compensation';
      case 8:
        return 'Allowances & Benefits';
      case 9:
        return 'Bonuses & Incentives';
      case 10:
        return 'Adjustments';
      case 11:
        return 'Bulk Adjustments';
      case 12:
        return 'Salary Change History';
      case 13:
        return 'Merit Planning';
      case 14:
        return 'Revision History';
      default:
        return 'Grade Structure';
    }
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const GradeStructureManagementScreen();
      case 1:
        return const SetupAndConfigurationTab();
      case 2:
        return const LocalizationTab();
      case 3:
        return const ComponentsTab();
      case 4:
        return const ManageSalaryStructureTab();
      case 5:
        return const CompensationPlansTab();
      case 6:
        return const CompensationSimulationTab();
      case 7:
        return const EmployeeCompensationTab();
      case 8:
        return const AllowancesAndBenefitsTab();
      case 9:
        return const BonusesAndIncentivesTab();
      case 10:
        return const AdjustmentsTab();
      case 11:
        return const BulkAdjustmentsTab();
      case 12:
        return const SalaryChangeHistoryTab();
      case 13:
        return const MeritPlanningTab();
      case 14:
        return const RevisionHistoryTab();
      default:
        return const SizedBox();
    }
  }
}
