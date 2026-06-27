import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/nav_item_ids.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/permissions/permission_visibility_mixin.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/gen/assets.gen.dart';

import 'dashboard_button_model.dart';

final _dashboardPermissionVisibility = _DashboardPermissionVisibility();

class _DashboardPermissionVisibility with PermissionVisibilityMixin {}

List<DashboardButton> getDashboardButtons(AppLocalizations loc) {
  final buttons = [
    DashboardButton(
      id: NavItemIds.jobSchedulesButton,
      icon: Assets.icons.timeManagementMainIcon.path,
      label: 'Job Schedules',
      color: AppColors.dashJobSchedules,
      route: '/job-schedules',
    ),
    DashboardButton(
      id: NavItemIds.employeeSelfServiceButton,
      icon: Assets.icons.managementIconDepartment.path,
      label: 'Employee Self-\nService',
      color: AppColors.primary,
      route: '/employee-ss',
      isMultiLine: true,
    ),
    DashboardButton(
      id: 'manager-ss',
      icon: Assets.icons.employeesCountIcon.path,
      label: 'Manager Self-\nService',
      color: AppColors.dashManagerSS,
      route: '/manager-ss',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.dashboard,
      icon: Assets.icons.dashboardMainIcon.path,
      label: loc.dashboard,
      color: AppColors.primaryLight,
      route: '/dashboard',
    ),
    DashboardButton(
      id: NavItemIds.employees,
      icon: Assets.icons.employeesCountIcon.path,
      label: 'Employee\nManagement',
      color: AppColors.statIconGreen,
      route: '/employees',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.hrOperationsButton,
      icon: Assets.icons.departmentsSmallIcon.path,
      label: 'HR Operations',
      color: AppColors.dashHROps,
      route: '/hr-ops',
    ),
    DashboardButton(
      id: 'recruitment',
      icon: Assets.icons.searchDepartmentIcon.path,
      label: 'Recruitment',
      color: AppColors.dashRecruitment,
      route: '/recruitment',
    ),
    DashboardButton(
      id: NavItemIds.timeManagementButton,
      icon: Assets.icons.timeManagementMainIcon.path,
      label: 'Time\nManagement',
      color: AppColors.statIconOrange,
      route: '/time-management',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.leaveManagementButton,
      icon: Assets.icons.leaveManagementMainIcon.path,
      label: 'Leave\nManagement',
      color: AppColors.dashLeaveManagement,
      route: '/leave-management',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.timeTrackingAttendanceButton,
      icon: Assets.icons.timeManagementMainIcon.path,
      label: 'Time Tracking & Attendance',
      isMultiLine: true,
      color: AppColors.dashAttendance,
      route: '/time-tracking-attendance',
    ),
    DashboardButton(
      id: NavItemIds.compensation,
      icon: Assets.icons.gradeIcon.path,
      label: 'Compensation',
      color: AppColors.dashCompensation,
      route: '/compensation',
    ),
    DashboardButton(
      id: NavItemIds.securityManager,
      icon: Assets.icons.securityIcon.path,
      label: 'Security Manager',
      color: AppColors.dashManagerSS,
      route: '/security-console',
    ),
    DashboardButton(
      id: NavItemIds.payroll,
      icon: Assets.icons.websiteIcon.path,
      label: loc.payroll,
      color: AppColors.dashPayroll,
      route: '/payroll',
    ),

    DashboardButton(
      id: NavItemIds.grc,
      icon: Assets.icons.complianceMainIcon.path,
      label: loc.grc,
      color: AppColors.dashCompliance,
      route: AppRoutes.grc,
    ),
    DashboardButton(
      id: NavItemIds.workforceStructureButton,
      icon: Assets.icons.workforceStructureIcon.path,
      label: 'Workforce\nStructure',
      color: AppColors.dashWorkforceStructure,
      route: '/workforce-structure',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.enterpriseStructureButton,
      icon: Assets.icons.workforceStructureMainIcon.path,
      label: 'Enterprise\nStructure',
      color: AppColors.dashEnterpriseStructure,
      route: '/enterprise-structure',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.reports,
      icon: Assets.icons.sectionIconPurple.path,
      label: loc.reports,
      color: AppColors.dashReports,
      route: '/reports',
    ),
    DashboardButton(
      id: NavItemIds.eosCalculatorButton,
      icon: Assets.icons.reportsMainIcon.path,
      label: loc.eosCalculator,
      color: AppColors.dashEOSCalculator,
      route: '/eos-calculator',
    ),
    DashboardButton(
      id: NavItemIds.governmentFormsButton,
      icon: Assets.icons.eosCalculatorMainIcon.path,
      label: 'Government\nForms',
      color: AppColors.dashGovernmentForms,
      route: '/government-forms',
      isMultiLine: true,
    ),
    DashboardButton(
      id: NavItemIds.deiDashboardButton,
      icon: Assets.icons.industryIcon.path,
      label: loc.deiDashboard,
      color: AppColors.dashDEIDashboard,
      route: '/dei-dashboard',
    ),
    DashboardButton(
      id: 'finance',
      icon: Assets.icons.websiteIcon.path,
      label: 'Finance',
      color: AppColors.dashFinance,
      route: '/finance',
    ),
    DashboardButton(
      id: 'supply-chain',
      icon: Assets.icons.supplyChain.path,
      label: 'Supply Chain',
      color: AppColors.dashSupplyChain,
      route: '/supply-chain',
    ),
    DashboardButton(
      id: 'module-catalogue',
      icon: Assets.icons.moduleCatalogueIcon.path,
      label: 'Module\nCatalogue',
      color: AppColors.dashModuleCatalogue,
      route: '/module-catalogue',
      isMultiLine: true,
    ),
    DashboardButton(
      id: 'product-intro',
      icon: Assets.icons.moduleCatalogueMainIcon.path,
      label: 'Product\nIntroduction',
      color: AppColors.dashProductIntro,
      route: '/product-intro',
      isMultiLine: true,
    ),
    DashboardButton(
      id: 'page-preview',
      icon: Assets.icons.sectionIconPurple.path,
      label: 'Page Preview',
      color: AppColors.dashPagePreview,
      route: '/page-preview',
    ),
    DashboardButton(
      id: NavItemIds.settings,
      icon: Assets.icons.manageEnterpriseIcon.path,
      label: loc.settings,
      color: AppColors.dashSettings,
      route: '/settings',
    ),
    DashboardButton(
      id: NavItemIds.hiring,
      icon: Assets.icons.hiring.jobSeekerIcon.path,
      label: loc.hiring,
      color: AppColors.dashRecruitment,
      route: AppRoutes.hiring,
    ),
    DashboardButton(
      id: NavItemIds.developerTools,
      icon: Assets.icons.developerTools.mainIcon.path,
      label: 'Developer Tools',
      color: AppColors.dashManagerSS,
      route: AppRoutes.developerTools,
    ),
  ];

  return buttons.where((button) => _dashboardPermissionVisibility.canAccessDashboardButtonId(button.id)).toList();
}
