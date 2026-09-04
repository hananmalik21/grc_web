import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/cloud_posture/finding_item_model.dart';
import 'package:grc/core/models/cyber_security/network_security/firewall_rule_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/network_security/dialogs/ai_rule_analysis_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/network_security/widgets/firewall_rules_table.dart';
import 'package:grc/features/cyber_security/sub_modules/network_security/widgets/network_kpi_row.dart';

class NetworkSecurityScreen extends StatefulWidget {
  const NetworkSecurityScreen({super.key});

  @override
  State<NetworkSecurityScreen> createState() => _NetworkSecurityScreenState();
}

class _NetworkSecurityScreenState extends State<NetworkSecurityScreen> {
  final List<FirewallRuleModel> _rules = const [
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

  @override
  Widget build(BuildContext context) {
    return CyberScreenLayout(
      title: 'Network Security',
      subtitle: 'Firewall rules, exposure scoring, and attack path analysis',
      actions: [
        AppButton(
          label: 'Scan Boundary',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: () {
            ToastService.show(
              context: context,
              message:
                  'Live network boundary & firewall exposure scan active...',
              type: ToastType.info,
            );
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NetworkKpiRow(),
          const Gap(24),
          FirewallRulesTable(
            rules: _rules,
            onAnalyzeRule: (rule) =>
                AiRuleAnalysisDialog.show(context, rule: rule),
          ),
        ],
      ),
    );
  }
}
