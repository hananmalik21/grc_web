import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/configs/menu_feature_config.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/permissions/permission_visibility_mixin.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/gen/assets.gen.dart';

final _sidebarPermissionVisibility = _SidebarPermissionVisibility();

class _SidebarPermissionVisibility with PermissionVisibilityMixin {}

class SidebarConfig {
  static bool _hasPermission(SidebarItem item) {
    return _sidebarPermissionVisibility.canAccessSidebarItemId(item.id);
  }

  static List<SidebarItem> _filterItems(List<SidebarItem> items) {
    final result = <SidebarItem>[];
    for (final item in items) {
      if (!MenuFeatureConfig.isEnabled(item.id)) continue;
      if (item.children != null) {
        if (!_hasPermission(item)) continue;
        final filteredChildren = _filterItems(item.children!);
        if (filteredChildren.isEmpty) continue;
        result.add(
          SidebarItem(
            id: item.id,
            icon: item.icon,
            svgPath: item.svgPath,
            labelKey: item.labelKey,
            children: filteredChildren,
            route: item.route,
            subtitle: item.subtitle,
          ),
        );
      } else {
        if (!_hasPermission(item)) continue;
        result.add(item);
      }
    }
    return result;
  }

  static List<SidebarItem> getMenuItems() {
    return _filterItems([
      SidebarItem(
        id: 'dashboard',
        svgPath: Assets.icons.dashboardIcon.path,
        labelKey: 'dashboard',
        route: AppRoutes.dashboard,
      ),
      SidebarItem(
        id: 'enterpriseStructure',
        svgPath: Assets.icons.enterpriseStructureIcon.path,
        labelKey: 'enterpriseStructure',
        subtitle: 'Company, division, department & more',
        children: [
          SidebarItem(
            id: 'manageEnterpriseStructure',
            svgPath: Assets.icons.manageEnterpriseIcon.path,
            labelKey: 'manageEnterpriseStructure',
            route: AppRoutes.enterpriseStructure,
          ),
          SidebarItem(
            id: 'manageComponentValues',
            svgPath: Assets.icons.manageComponentIcon.path,
            labelKey: 'manageComponentValues',
            route: AppRoutes.enterpriseStructure,
          ),
          SidebarItem(
            id: 'company',
            svgPath: Assets.icons.companyIcon.path,
            labelKey: 'company',
            route: AppRoutes.enterpriseStructure,
          ),
          SidebarItem(
            id: 'division',
            svgPath: Assets.icons.divisionIcon.path,
            labelKey: 'division',
            route: AppRoutes.enterpriseStructure,
          ),
          SidebarItem(
            id: 'businessUnit',
            svgPath: Assets.icons.businessUnitIcon.path,
            labelKey: 'businessUnit',
            route: AppRoutes.enterpriseStructure,
          ),
          SidebarItem(
            id: 'department',
            svgPath: Assets.icons.departmentIcon.path,
            labelKey: 'department',
            route: AppRoutes.enterpriseStructure,
          ),
          SidebarItem(
            id: 'section',
            svgPath: Assets.icons.sectionIcon.path,
            labelKey: 'section',
            route: AppRoutes.enterpriseStructure,
          ),
        ],
      ),
      SidebarItem(
        id: 'securityManager',
        svgPath: Assets.icons.securityIcon.path,
        labelKey: 'securityManager',
        subtitle: 'Comprehensive Security and Access Control',
        children: [
          SidebarItem(
            id: 'securityOverview',
            svgPath: Assets.icons.securityIcon.path,
            labelKey: 'securityOverview',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'userManagement',
            svgPath: Assets.icons.usersIcon.path,
            labelKey: 'userManagement',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'accessManagement',
            svgPath: Assets.icons.auth.secureShield.path,
            labelKey: 'accessManagement',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'rolesManagement',
            svgPath: Assets.icons.securityManager.applicationRoles.path,
            labelKey: 'rolesManagement',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'securityPolicies',
            svgPath: Assets.icons.manageEnterpriseIcon.path,
            labelKey: 'securityPolicies',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'activeSessions',
            svgPath: Assets.icons.securityManager.activeSession.path,
            labelKey: 'activeSessions',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'securityAlerts',
            svgPath: Assets.icons.securityManager.securityAlerts.path,
            labelKey: 'securityAlerts',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'dataClassification',
            svgPath: Assets.icons.securityManager.dataClassification.path,
            labelKey: 'dataClassification',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'roleDelegation',
            svgPath: Assets.icons.securityManager.roleDelegation.path,
            labelKey: 'roleDelegation',
            route: AppRoutes.securityManager,
          ),
          SidebarItem(
            id: 'segregationOfDuties',
            svgPath: Assets.icons.securityManager.segregation.path,
            labelKey: 'segregationOfDuties',
            route: AppRoutes.securityManager,
          ),
        ],
      ),
      SidebarItem(
        id: 'grc',
        svgPath: Assets.icons.complianceIcon.path,
        labelKey: 'grc',
        subtitle: 'Governance, Risk & Compliance',
        children: [
          SidebarItem(
            id: 'grcDashboard',
            labelKey: 'grcDashboard',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.dashboardIcon.path,
          ),
          SidebarItem(
            id: 'grcLibrary',
            labelKey: 'grcLibrary',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.libraryIcon.path,
          ),
          SidebarItem(
            id: 'grcAssets',
            labelKey: 'grcAssets',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.assetsIcon.path,
          ),
          SidebarItem(
            id: 'grcRisks',
            labelKey: 'grcRisks',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.securityIcon.path,
          ),
          SidebarItem(
            id: 'grcAssessments',
            labelKey: 'grcAssessments',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.assessmentsIcon.path,
          ),
          SidebarItem(
            id: 'grcControls',
            labelKey: 'grcControls',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.controlsIcon.path,
          ),
          SidebarItem(
            id: 'grcTprm',
            labelKey: 'grcTprm',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.usersIcon.path,
          ),
          SidebarItem(
            id: 'grcPrograms',
            labelKey: 'grcPrograms',
            route: AppRoutes.grc,
            svgPath: Assets.grc.figma.dashboard.svg.programsIcon.path,
          ),
        ],
      ),
    ]);
  }

  static String getLocalizedLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'dashboard':
        return localizations.dashboard;
      case 'enterpriseStructure':
        return localizations.enterpriseStructure;
      case 'manageEnterpriseStructure':
        return 'Manage Enterprise\nStructure';
      case 'manageComponentValues':
        return localizations.manageComponentValues;
      case 'company':
        return 'Company';
      case 'division':
        return 'Division';
      case 'businessUnit':
        return 'Business Unit';
      case 'department':
        return 'Department';
      case 'section':
        return 'Section';
      case 'securityManager':
        return 'Security Manager';
      case 'securityOverview':
        return 'Security Overview';
      case 'userManagement':
        return 'User Management';
      case 'accessManagement':
        return 'Access Management';
      case 'rolesManagement':
        return 'Roles Management';
      case 'securityPolicies':
        return localizations.securityPolicies;
      case 'activeSessions':
        return localizations.activeSessions;
      case 'securityAlerts':
        return localizations.securityAlerts;
      case 'dataClassification':
        return 'Data Classification';
      case 'roleDelegation':
        return 'Role Delegation';
      case 'segregationOfDuties':
        return localizations.segregationOfDuties;
      case 'grc':
        return localizations.grc;
      case 'grcDashboard':
        return localizations.grcDashboard;
      case 'grcLibrary':
        return localizations.grcLibrary;
      case 'grcAssets':
        return localizations.grcAssets;
      case 'grcRisks':
        return localizations.grcRisks;
      case 'grcAssessments':
        return localizations.grcAssessments;
      case 'grcControls':
        return localizations.grcControls;
      case 'grcTprm':
        return localizations.grcTprm;
      case 'grcPrograms':
        return localizations.grcPrograms;
      default:
        return key;
    }
  }

  static String? getLocalizedDescription(
    String key,
    AppLocalizations localizations,
  ) {
    switch (key) {
      case 'grcDashboard':
        return localizations.grcDashboardDescription;
      case 'grcLibrary':
        return localizations.grcLibraryDescription;
      case 'grcAssets':
        return localizations.grcAssetsDescription;
      case 'grcRisks':
        return localizations.grcRisksDescription;
      case 'grcAssessments':
        return localizations.grcAssessmentsDescription;
      case 'grcControls':
        return localizations.grcControlsDescription;
      case 'grcTprm':
        return localizations.grcTprmDescription;
      case 'grcPrograms':
        return localizations.grcProgramsDescription;
      default:
        return null;
    }
  }
}
