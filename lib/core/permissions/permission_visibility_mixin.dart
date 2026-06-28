import 'package:digify_core/permissions/perm_module.dart';
import 'package:grc/core/enums/nav_item_ids.dart';
import 'package:grc/core/permissions/perm_catalog.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin PermissionVisibilityMixin {
  static final Map<String, PermModule> _sidebarModuleByItemId = {
    NavItemIds.dashboard: kDashboardModule,
    NavItemIds.enterpriseStructure: kEnterpriseStructureModule,
    NavItemIds.securityManager: kSecurityModule,
    NavItemIds.grc: kGrcModule,
  };

  static final Map<String, String> _sidebarPermissionKeyByItemId = {
    'manageEnterpriseStructure':
        EnterpriseStructurePermKeys.enterpriseStructureManageView,
    'manageComponentValues':
        EnterpriseStructurePermKeys.enterpriseComponentValuesView,
    'company': EnterpriseStructurePermKeys.enterpriseCompanyView,
    'division': EnterpriseStructurePermKeys.enterpriseDivisionView,
    'businessUnit': EnterpriseStructurePermKeys.enterpriseBusinessUnitView,
    'department': EnterpriseStructurePermKeys.enterpriseDepartmentView,
    'section': EnterpriseStructurePermKeys.enterpriseSectionView,
    'securityOverview': PermKeys.securityOverviewView,
    'userManagement': PermKeys.securityUserManagementView,
    'accessManagement': PermKeys.securityAccessManagementView,
    'rolesManagement': PermKeys.securityRolesManagementView,
    'securityPolicies': PermKeys.securityPoliciesView,
    'activeSessions': PermKeys.securityActiveSessionsView,
    'securityAlerts': PermKeys.securityAlertsView,
    'dataClassification': PermKeys.securityDataClassificationView,
    'roleDelegation': PermKeys.securityRoleDelegationView,
    'segregationOfDuties': PermKeys.securitySegregationOfDutiesView,
    NavItemIds.grcDashboard: PermKeys.grcDashboardView,
    NavItemIds.grcLibrary: PermKeys.grcLibraryView,
    NavItemIds.grcAssets: PermKeys.grcAssetsView,
    NavItemIds.grcRisks: PermKeys.grcRisksView,
    NavItemIds.grcAssessments: PermKeys.grcAssessmentsView,
    NavItemIds.grcControls: PermKeys.grcControlsView,
    NavItemIds.grcTprm: PermKeys.grcTprmView,
    NavItemIds.grcPrograms: PermKeys.grcProgramsView,
    NavItemIds.grcReviewProgress: PermKeys.grcReviewProgressView,
  };

  static final Map<String, PermModule> _dashboardModuleByButtonId = {
    NavItemIds.enterpriseStructureButton: kEnterpriseStructureModule,
    NavItemIds.securityManager: kSecurityModule,
    NavItemIds.grc: kGrcModule,
  };

  static final Map<String, String> _dashboardPermissionKeyByButtonId = {};

  bool canAccessSidebarItemId(String itemId) {
    if (PermissionService.instance.isBypassAllPermissions) return true;
    if (itemId == NavItemIds.dashboard) {
      return true;
    }
    return _canAccess(
      id: itemId,
      moduleMap: _sidebarModuleByItemId,
      keyMap: _sidebarPermissionKeyByItemId,
    );
  }

  bool canAccessDashboardButtonId(String buttonId) {
    if (PermissionService.instance.isBypassAllPermissions) return true;
    return _canAccess(
      id: buttonId,
      moduleMap: _dashboardModuleByButtonId,
      keyMap: _dashboardPermissionKeyByButtonId,
    );
  }

  bool _canAccess({
    required String id,
    required Map<String, PermModule> moduleMap,
    required Map<String, String> keyMap,
  }) {
    final module = moduleMap[id];
    if (module != null) {
      return PermissionService.instance.canSeeModule(module);
    }

    final permissionKey = keyMap[id];
    if (permissionKey == null) return false;
    return PermissionService.instance.can(permissionKey);
  }
}
