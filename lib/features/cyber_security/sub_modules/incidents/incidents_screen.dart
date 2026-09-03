import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/incidents/incident_item_model.dart';
import 'package:grc/core/permissions/permission_gate.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/models/threat_dto.dart';
import 'package:grc/features/cyber_security/presentation/providers/threat_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/incident_ai_triage_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/widgets/incident_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/widgets/incidents_table.dart';

class IncidentsScreen extends ConsumerWidget {
  const IncidentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!PermissionService.instance.can(CyberPermKeys.threatRead)) {
      return PermissionGate(
        permKey: CyberPermKeys.threatRead,
        fallback: _permissionDenied(),
        child: const SizedBox.shrink(),
      );
    }
    final threats = ref.watch(liveThreatsProvider);
    return threats.when(
      loading: () => _buildLayout(context, ref, const []),
      error: (error, stack) => _buildLayout(context, ref, const []),
      data: (items) =>
          _buildLayout(context, ref, items.map(_toIncident).toList()),
    );
  }

  Widget _permissionDenied() => CyberScreenLayout(
    title: 'Incident Response & SOAR',
    subtitle: 'You do not have permission to view threat telemetry.',
    child: const SizedBox.shrink(),
  );

  IncidentItemModel _toIncident(ThreatDto threat) {
    final status = switch (threat.status.toUpperCase()) {
      'INVESTIGATING' => IncidentStatus.investigating,
      'MITIGATED' => IncidentStatus.contained,
      'FALSE_POSITIVE' => IncidentStatus.resolved,
      _ => IncidentStatus.open,
    };
    final severity = switch (threat.severity.toUpperCase()) {
      'CRITICAL' => IncidentSeverity.critical,
      'HIGH' => IncidentSeverity.high,
      'MEDIUM' => IncidentSeverity.medium,
      _ => IncidentSeverity.low,
    };
    return IncidentItemModel(
      id: threat.id,
      title: threat.title,
      severity: severity,
      status: status,
      owner: 'Not assigned',
      createdDate: threat.occurredAt?.toLocal().toString() ?? 'Recently',
      mitreCode: threat.mitreTechniqueId ?? 'Not available',
      description:
          threat.aiAnalysisSummary ??
          'Incident correlated from security telemetry.',
      evidence: [
        if (threat.associatedActor != null) 'Actor: ${threat.associatedActor}',
        if (threat.associatedIp != null) 'Source IP: ${threat.associatedIp}',
      ],
    );
  }

  Widget _buildLayout(
    BuildContext context,
    WidgetRef ref,
    List<IncidentItemModel> incidents,
  ) {
    final openCount = incidents
        .where((i) => i.status == IncidentStatus.open)
        .length;
    final investigatingCount = incidents
        .where((i) => i.status == IncidentStatus.investigating)
        .length;
    final containedCount = incidents
        .where((i) => i.status == IncidentStatus.contained)
        .length;
    final resolvedCount = incidents
        .where((i) => i.status == IncidentStatus.resolved)
        .length;

    return CyberScreenLayout(
      title: 'Incident Response & SOAR',
      subtitle:
          'Triage queue, automated playbooks, MTTR tracking, and evidence correlation',
      actions: [
        AppButton(
          label: 'Export CSV',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: null,
        ),
        const Gap(8),
        AppButton(
          label: 'Log Incident',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: null,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IncidentKpiRow(
            openCount: openCount,
            investigatingCount: investigatingCount,
            containedCount: containedCount,
            resolvedCount: resolvedCount,
          ),
          const Gap(24),
          IncidentsTable(
            incidents: incidents,
            onTakeOwnership: (incident) async {
              await ref
                  .read(threatRepositoryProvider)
                  .updateStatus(incident.id, 'INVESTIGATING');
              ref.invalidate(liveThreatsProvider);
            },
            onTriage: (incident) {
              showDialog(
                context: context,
                builder: (ctx) => IncidentAiTriageDialog(
                  incident: incident,
                  onExecuteContainment: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
