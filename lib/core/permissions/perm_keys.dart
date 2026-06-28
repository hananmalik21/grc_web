import 'perm_action.dart';
import 'perm_catalog.dart';

class PermKeys {
  PermKeys._();

  static final dashboardAll = kDashboardModule.subModules[0].wildcard;
  static final dashboardCreate = kDashboardModule.subModules[0].action(
    PermAction.create,
  );
  static final dashboardView = kDashboardModule.subModules[0].action(
    PermAction.view,
  );
  static final dashboardUpdate = kDashboardModule.subModules[0].action(
    PermAction.update,
  );
  static final dashboardDelete = kDashboardModule.subModules[0].action(
    PermAction.delete,
  );

  static final enterpriseStructureManageAll =
      kEnterpriseStructureModule.subModules[0].wildcard;
  static final enterpriseStructureManageCreate = kEnterpriseStructureModule
      .subModules[0]
      .action(PermAction.create);
  static final enterpriseStructureManageView = kEnterpriseStructureModule
      .subModules[0]
      .action(PermAction.view);
  static final enterpriseStructureManageUpdate = kEnterpriseStructureModule
      .subModules[0]
      .action(PermAction.update);
  static final enterpriseStructureManageDelete = kEnterpriseStructureModule
      .subModules[0]
      .action(PermAction.delete);
  static final enterpriseStructureManageActivate = kEnterpriseStructureModule
      .subModules[0]
      .action(PermAction.activate);

  static final enterpriseComponentValuesAll =
      kEnterpriseStructureModule.subModules[1].wildcard;
  static final enterpriseComponentValuesCreate = kEnterpriseStructureModule
      .subModules[1]
      .action(PermAction.create);
  static final enterpriseComponentValuesView = kEnterpriseStructureModule
      .subModules[1]
      .action(PermAction.view);
  static final enterpriseComponentValuesUpdate = kEnterpriseStructureModule
      .subModules[1]
      .action(PermAction.update);
  static final enterpriseComponentValuesDelete = kEnterpriseStructureModule
      .subModules[1]
      .action(PermAction.delete);

  static final enterpriseCompanyAll =
      kEnterpriseStructureModule.subModules[2].wildcard;
  static final enterpriseCompanyCreate = kEnterpriseStructureModule
      .subModules[2]
      .action(PermAction.create);
  static final enterpriseCompanyView = kEnterpriseStructureModule.subModules[2]
      .action(PermAction.view);
  static final enterpriseCompanyUpdate = kEnterpriseStructureModule
      .subModules[2]
      .action(PermAction.update);
  static final enterpriseCompanyDelete = kEnterpriseStructureModule
      .subModules[2]
      .action(PermAction.delete);

  static final enterpriseDivisionAll =
      kEnterpriseStructureModule.subModules[3].wildcard;
  static final enterpriseDivisionCreate = kEnterpriseStructureModule
      .subModules[3]
      .action(PermAction.create);
  static final enterpriseDivisionView = kEnterpriseStructureModule.subModules[3]
      .action(PermAction.view);
  static final enterpriseDivisionUpdate = kEnterpriseStructureModule
      .subModules[3]
      .action(PermAction.update);
  static final enterpriseDivisionDelete = kEnterpriseStructureModule
      .subModules[3]
      .action(PermAction.delete);

  static final enterpriseBusinessUnitAll =
      kEnterpriseStructureModule.subModules[4].wildcard;
  static final enterpriseBusinessUnitCreate = kEnterpriseStructureModule
      .subModules[4]
      .action(PermAction.create);
  static final enterpriseBusinessUnitView = kEnterpriseStructureModule
      .subModules[4]
      .action(PermAction.view);
  static final enterpriseBusinessUnitUpdate = kEnterpriseStructureModule
      .subModules[4]
      .action(PermAction.update);
  static final enterpriseBusinessUnitDelete = kEnterpriseStructureModule
      .subModules[4]
      .action(PermAction.delete);

  static final enterpriseDepartmentAll =
      kEnterpriseStructureModule.subModules[5].wildcard;
  static final enterpriseDepartmentCreate = kEnterpriseStructureModule
      .subModules[5]
      .action(PermAction.create);
  static final enterpriseDepartmentView = kEnterpriseStructureModule
      .subModules[5]
      .action(PermAction.view);
  static final enterpriseDepartmentUpdate = kEnterpriseStructureModule
      .subModules[5]
      .action(PermAction.update);
  static final enterpriseDepartmentDelete = kEnterpriseStructureModule
      .subModules[5]
      .action(PermAction.delete);

  static final enterpriseSectionAll =
      kEnterpriseStructureModule.subModules[6].wildcard;
  static final enterpriseSectionCreate = kEnterpriseStructureModule
      .subModules[6]
      .action(PermAction.create);
  static final enterpriseSectionView = kEnterpriseStructureModule.subModules[6]
      .action(PermAction.view);
  static final enterpriseSectionUpdate = kEnterpriseStructureModule
      .subModules[6]
      .action(PermAction.update);
  static final enterpriseSectionDelete = kEnterpriseStructureModule
      .subModules[6]
      .action(PermAction.delete);

  static final securityOverviewAll = kSecurityModule.subModules[0].wildcard;
  static final securityOverviewView = kSecurityModule.subModules[0].action(
    PermAction.view,
  );

  static final securityUserManagementAll =
      kSecurityModule.subModules[1].wildcard;
  static final securityUserManagementCreate = kSecurityModule.subModules[1]
      .action(PermAction.create);
  static final securityUserManagementView = kSecurityModule.subModules[1]
      .action(PermAction.view);
  static final securityUserManagementUpdate = kSecurityModule.subModules[1]
      .action(PermAction.update);
  static final securityUserManagementDelete = kSecurityModule.subModules[1]
      .action(PermAction.delete);

  static final securityAccessManagementAll =
      kSecurityModule.subModules[2].wildcard;
  static final securityAccessManagementCreate = kSecurityModule.subModules[2]
      .action(PermAction.create);
  static final securityAccessManagementView = kSecurityModule.subModules[2]
      .action(PermAction.view);
  static final securityAccessManagementUpdate = kSecurityModule.subModules[2]
      .action(PermAction.update);
  static final securityAccessManagementDelete = kSecurityModule.subModules[2]
      .action(PermAction.delete);

  static final securityRolesManagementAll =
      kSecurityModule.subModules[3].wildcard;
  static final securityRolesManagementCreate = kSecurityModule.subModules[3]
      .action(PermAction.create);
  static final securityRolesManagementView = kSecurityModule.subModules[3]
      .action(PermAction.view);
  static final securityRolesManagementUpdate = kSecurityModule.subModules[3]
      .action(PermAction.update);
  static final securityRolesManagementDelete = kSecurityModule.subModules[3]
      .action(PermAction.delete);

  static final securityPoliciesAll = kSecurityModule.subModules[4].wildcard;
  static final securityPoliciesCreate = kSecurityModule.subModules[4].action(
    PermAction.create,
  );
  static final securityPoliciesView = kSecurityModule.subModules[4].action(
    PermAction.view,
  );
  static final securityPoliciesUpdate = kSecurityModule.subModules[4].action(
    PermAction.update,
  );

  static final securityActiveSessionsAll =
      kSecurityModule.subModules[5].wildcard;
  static final securityActiveSessionsView = kSecurityModule.subModules[5]
      .action(PermAction.view);
  static final securityActiveSessionsDelete = kSecurityModule.subModules[5]
      .action(PermAction.delete);

  static final securityAlertsAll = kSecurityModule.subModules[6].wildcard;
  static final securityAlertsView = kSecurityModule.subModules[6].action(
    PermAction.view,
  );
  static final securityAlertsUpdate = kSecurityModule.subModules[6].action(
    PermAction.update,
  );

  static final securityDataClassificationAll =
      kSecurityModule.subModules[7].wildcard;
  static final securityDataClassificationCreate = kSecurityModule.subModules[7]
      .action(PermAction.create);
  static final securityDataClassificationView = kSecurityModule.subModules[7]
      .action(PermAction.view);
  static final securityDataClassificationUpdate = kSecurityModule.subModules[7]
      .action(PermAction.update);
  static final securityDataClassificationDelete = kSecurityModule.subModules[7]
      .action(PermAction.delete);

  static final securityRoleDelegationAll =
      kSecurityModule.subModules[8].wildcard;
  static final securityRoleDelegationCreate = kSecurityModule.subModules[8]
      .action(PermAction.create);
  static final securityRoleDelegationView = kSecurityModule.subModules[8]
      .action(PermAction.view);
  static final securityRoleDelegationUpdate = kSecurityModule.subModules[8]
      .action(PermAction.update);
  static final securityRoleDelegationDelete = kSecurityModule.subModules[8]
      .action(PermAction.delete);

  static final securitySegregationOfDutiesAll =
      kSecurityModule.subModules[9].wildcard;
  static final securitySegregationOfDutiesCreate = kSecurityModule.subModules[9]
      .action(PermAction.create);
  static final securitySegregationOfDutiesView = kSecurityModule.subModules[9]
      .action(PermAction.view);
  static final securitySegregationOfDutiesUpdate = kSecurityModule.subModules[9]
      .action(PermAction.update);

  static final grcDashboardView = kGrcModule.subModules[0].action(
    PermAction.view,
  );
  static final grcLibraryView = kGrcModule.subModules[1].action(
    PermAction.view,
  );
  static final grcAssetsView = kGrcModule.subModules[2].action(PermAction.view);
  static final grcRisksView = kGrcModule.subModules[3].action(PermAction.view);
  static final grcAssessmentsView = kGrcModule.subModules[4].action(
    PermAction.view,
  );
  static final grcControlsView = kGrcModule.subModules[5].action(
    PermAction.view,
  );
  static final grcTprmView = kGrcModule.subModules[6].action(PermAction.view);
  static final grcProgramsView = kGrcModule.subModules[7].action(
    PermAction.view,
  );
  static final grcReviewProgressView = kGrcModule.subModules[8].action(
    PermAction.view,
  );
}
