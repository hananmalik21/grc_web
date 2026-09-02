import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/threat_detection/threat_alert_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_threat_detection_mock_data.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/dialogs/create_detection_rule_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/widgets/threat_alerts_table.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/widgets/threat_detection_kpi_row.dart';

class ThreatDetectionScreen extends StatefulWidget {
  const ThreatDetectionScreen({super.key});

  @override
  State<ThreatDetectionScreen> createState() => _ThreatDetectionScreenState();
}

class _ThreatDetectionScreenState extends State<ThreatDetectionScreen> {
  final List<ThreatAlertModel> _alerts = CyberThreatDetectionMockData.mockAlerts;

  void _openCreateRuleDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const CreateDetectionRuleDialog(),
    );
  }

  void _openFilterDialog() {
    ToastService.show(
      context: context,
      message: 'Filtering applied: Showing high & critical severity telemetry across all layers.',
      type: ToastType.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final newCount = _alerts.where((a) => a.status == ThreatStatus.new_).length;
    final investigatingCount =
        _alerts.where((a) => a.status == ThreatStatus.investigating).length;
    final criticalCount =
        _alerts.where((a) => a.severity == ThreatSeverity.critical).length;

    return CyberScreenLayout(
      title: 'Threat Detection',
      subtitle: 'Real-time telemetry, behavioral anomalies, and SIEM correlation',
      actions: [
        AppButton(
          label: 'Filter',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: _openFilterDialog,
        ),
        const Gap(8),
        AppButton(
          label: 'Create Rule',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: _openCreateRuleDialog,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThreatDetectionKpiRow(
            newAlertsCount: newCount,
            investigatingCount: investigatingCount,
            criticalTodayCount: criticalCount,
            detectionRulesCount: 247,
          ),
          const Gap(24),
          ThreatAlertsTable(alerts: _alerts),
        ],
      ),
    );
  }
}
