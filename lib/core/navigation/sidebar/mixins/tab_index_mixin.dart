mixin TabIndexMixin {
  int? getEnterpriseStructureTabIndex(String itemId) {
    switch (itemId) {
      case 'manageEnterpriseStructure':
        return 0;
      case 'manageComponentValues':
        return 1;
      case 'company':
        return 2;
      case 'division':
        return 3;
      case 'businessUnit':
        return 4;
      case 'department':
        return 5;
      case 'section':
        return 6;
      default:
        return null;
    }
  }

  int? getSecurityManagerTabIndex(String itemId) {
    switch (itemId) {
      case 'securityOverview':
        return 0;
      case 'userManagement':
        return 1;
      case 'accessManagement':
        return 2;
      case 'rolesManagement':
        return 3;
      case 'securityPolicies':
        return 4;
      case 'activeSessions':
        return 5;
      case 'securityAlerts':
        return 6;
      case 'dataClassification':
        return 7;
      case 'roleDelegation':
        return 8;
      case 'segregationOfDuties':
        return 9;
      default:
        return null;
    }
  }

  int? getGrcTabIndex(String itemId) {
    switch (itemId) {
      case 'grcDashboard':
        return 0;
      case 'grcLibrary':
        return 1;
      case 'grcAssets':
        return 2;
      case 'grcRisks':
        return 3;
      case 'grcAssessments':
        return 4;
      case 'grcControls':
        return 5;
      case 'grcTprm':
        return 6;
      case 'grcPrograms':
        return 7;
      case 'grcReviewProgress':
        return 8;
      default:
        return null;
    }
  }
}
