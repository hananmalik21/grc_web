import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/core/router/breadcrumb_nav_extra.dart';
import 'package:grc/core/widgets/common/digify_breadcrumb.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_management_tab_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/screens/employee_actions_screen.dart';
import 'package:grc/features/employee_management/presentation/screens/employee_contracts_screen.dart';
import 'package:grc/features/employee_management/presentation/screens/mark_attendance_screen.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees_screen.dart';
import 'package:grc/features/employee_management/presentation/screens/workforce_planning_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class _EmployeeManagementTabIndex {
  static const int manageEmployees = 0;
  static const int employeeActions = 1;
  static const int workforcePlanning = 2;
  static const int contracts = 3;
  static const int markAttendance = 4;
}

class EmployeeManagementScreen extends ConsumerWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedTabIndex = ref.watch(employeeManagementTabStateProvider.select((s) => s.currentTabIndex));
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('employees');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTab(localizations, selectedTabIndex);

    final isMobile = ResponsiveHelper.isMobile(context);

    ref.listen<int>(employeeManagementTabStateProvider.select((s) => s.currentTabIndex), (previous, next) {
      if (previous == _EmployeeManagementTabIndex.manageEmployees &&
          next != _EmployeeManagementTabIndex.manageEmployees) {
        ref.read(manageEmployeesListProvider.notifier).prepareForTabLeave();
      }
    });

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
                      DigifyBreadcrumbItem(label: localizations.employees),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),

          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(selectedTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case _EmployeeManagementTabIndex.manageEmployees:
        return const ManageEmployeesScreen();
      case _EmployeeManagementTabIndex.employeeActions:
        return const EmployeeActionsScreen();
      case _EmployeeManagementTabIndex.workforcePlanning:
        return const WorkforcePlanningScreen();
      case _EmployeeManagementTabIndex.contracts:
        return const EmployeeContractsScreen();
      case _EmployeeManagementTabIndex.markAttendance:
        return const MarkAttendanceScreen();
      default:
        return const ManageEmployeesScreen();
    }
  }

  String _childLabelForTab(AppLocalizations localizations, int tabIndex) {
    switch (tabIndex) {
      case _EmployeeManagementTabIndex.manageEmployees:
        return localizations.manageEmployees;
      case _EmployeeManagementTabIndex.employeeActions:
        return 'Employee Actions';
      case _EmployeeManagementTabIndex.workforcePlanning:
        return 'Workforce Planning';
      case _EmployeeManagementTabIndex.contracts:
        return 'Employee Contracts';
      case _EmployeeManagementTabIndex.markAttendance:
        return 'Mark Attendance';
      default:
        return localizations.manageEmployees;
    }
  }
}
