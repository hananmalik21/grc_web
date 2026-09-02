import 'package:grc/features/cyber_security/sub_modules/cloud_posture/models/finding_item_model.dart';

class FirewallRuleModel {
  final String ruleId;
  final String protocol;
  final String port;
  final String source;
  final bool isSourceExposed;
  final String destination;
  final bool isDestinationExposed;
  final String service;
  final FindingSeverity risk;

  const FirewallRuleModel({
    required this.ruleId,
    required this.protocol,
    required this.port,
    required this.source,
    this.isSourceExposed = false,
    required this.destination,
    this.isDestinationExposed = false,
    required this.service,
    required this.risk,
  });

  static List<FirewallRuleModel> getMockRules() => const [
    FirewallRuleModel(
      ruleId: 'FW-0091',
      protocol: 'TCP',
      port: '3389',
      source: '0.0.0.0/0',
      isSourceExposed: true,
      destination: '10.0.1.0/24',
      service: 'RDP',
      risk: FindingSeverity.critical,
    ),
    FirewallRuleModel(
      ruleId: 'FW-0087',
      protocol: 'TCP',
      port: '22',
      source: '0.0.0.0/0',
      isSourceExposed: true,
      destination: '10.0.2.0/24',
      service: 'SSH',
      risk: FindingSeverity.high,
    ),
    FirewallRuleModel(
      ruleId: 'FW-0074',
      protocol: 'TCP',
      port: '1433',
      source: '0.0.0.0/0',
      isSourceExposed: true,
      destination: '10.0.3.0/24',
      service: 'MSSQL',
      risk: FindingSeverity.critical,
    ),
    FirewallRuleModel(
      ruleId: 'FW-0063',
      protocol: 'ANY',
      port: 'ANY',
      source: '10.0.0.0/8',
      destination: '0.0.0.0/0',
      isDestinationExposed: true,
      service: 'Egress',
      risk: FindingSeverity.medium,
    ),
    FirewallRuleModel(
      ruleId: 'FW-0041',
      protocol: 'TCP',
      port: '443',
      source: '0.0.0.0/0',
      isSourceExposed: true,
      destination: '10.0.4.0/24',
      service: 'HTTPS',
      risk: FindingSeverity.low,
    ),
    FirewallRuleModel(
      ruleId: 'FW-0038',
      protocol: 'TCP',
      port: '80',
      source: '0.0.0.0/0',
      isSourceExposed: true,
      destination: '10.0.4.0/24',
      service: 'HTTP',
      risk: FindingSeverity.medium,
    ),
  ];
}
