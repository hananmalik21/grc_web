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

  int? getCyberSecurityTabIndex(String itemId) {
    switch (itemId) {
      case 'cyberDashboard':
        return 0;
      case 'cyberCloudPosture':
        return 1;
      case 'cyberIdentityAccess':
        return 2;
      case 'cyberNetworkSecurity':
        return 3;
      case 'cyberAppApi':
        return 4;
      case 'cyberDataSecurity':
        return 5;
      case 'cyberSocCopilot':
        return 6;
      case 'cyberThreatDetection':
        return 7;
      case 'cyberIncidents':
        return 8;
      case 'cyberGrcCompliance':
        return 9;
      case 'cyberAiGovernance':
        return 10;
      case 'cyberCloudConnectors':
        return 11;
      case 'cyberTelemetry':
        return 12;
      case 'cyberPeopleRisk':
        return 13;
      default:
        return null;
    }
  }
}
