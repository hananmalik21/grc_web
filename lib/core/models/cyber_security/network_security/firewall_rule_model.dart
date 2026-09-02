import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';

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
}
