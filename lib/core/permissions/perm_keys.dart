export 'package:digify_core/permissions/perm_keys.dart';
export 'package:digify_enterprise_structure/integration/es_suite_permissions.dart'
    show EnterpriseStructurePermKeys;

class CyberPermKeys {
  CyberPermKeys._();

  static const String dashboardRead = 'threat.telemetry.read';
  static const String cloudPostureRead = 'threat.telemetry.read';
  static const String iamPostureRead = 'threat.iam-posture.read';
  static const String iamPostureWrite = 'threat.iam-posture.write';
  static const String complianceRead = 'compliance.framework.read';
  static const String complianceCreate = 'compliance.assessment.create';
  static const String complianceRespond = 'compliance.assessment.respond';
  static const String threatRead = 'threat.telemetry.read';
  static const String threatWrite = 'threat.telemetry.write';
  static const String aiCopilotQuery = 'ai.assistant.query';
}
