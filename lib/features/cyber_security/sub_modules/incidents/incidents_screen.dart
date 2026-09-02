import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/incidents/incident_item_model.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_incidents_mock_data.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/create_incident_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/dialogs/incident_ai_triage_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/widgets/incident_kpi_row.dart';
import 'package:grc/features/cyber_security/sub_modules/incidents/widgets/incidents_table.dart';

class IncidentsScreen extends StatefulWidget {
  const IncidentsScreen({super.key});

  @override
  State<IncidentsScreen> createState() => _IncidentsScreenState();
}

class _IncidentsScreenState extends State<IncidentsScreen> {
  late List<IncidentItemModel> _incidents;

  @override
  void initState() {
    super.initState();
    _incidents = List.from(CyberIncidentsMockData.mockIncidents);
  }

  void _openCreateIncidentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => CreateIncidentDialog(
        onCreated: (newIncident) {
          setState(() {
            _incidents.insert(0, newIncident);
          });
        },
      ),
    );
  }

  void _exportIncidents() {
    ToastService.show(
      context: context,
      message: 'Incident report exported to CSV and compliance archive.',
      type: ToastType.success,
    );
  }

  void _handleTakeOwnership(IncidentItemModel incident) {
    setState(() {
      final index = _incidents.indexWhere((i) => i.id == incident.id);
      if (index != -1) {
        _incidents[index] = _incidents[index].copyWith(
          owner: 'P. Nair',
          status: IncidentStatus.investigating,
        );
      }
    });
    ToastService.show(
      context: context,
      message: 'You have taken ownership of ${incident.id}. Status updated to Investigating.',
      type: ToastType.success,
    );
  }

  void _handleExecuteContainment(IncidentItemModel incident) {
    setState(() {
      final index = _incidents.indexWhere((i) => i.id == incident.id);
      if (index != -1) {
        _incidents[index] = _incidents[index].copyWith(
          status: IncidentStatus.contained,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final openCount = _incidents.where((i) => i.status == IncidentStatus.open).length;
    final investigatingCount = _incidents.where((i) => i.status == IncidentStatus.investigating).length;
    final containedCount = _incidents.where((i) => i.status == IncidentStatus.contained).length;
    final resolvedCount = _incidents.where((i) => i.status == IncidentStatus.resolved).length;

    return CyberScreenLayout(
      title: 'Incident Response & SOAR',
      subtitle: 'Triage queue, automated playbooks, MTTR tracking, and evidence correlation',
      actions: [
        AppButton(
          label: 'Export CSV',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: _exportIncidents,
        ),
        const Gap(8),
        AppButton(
          label: 'Log Incident',
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          onPressed: _openCreateIncidentDialog,
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
            incidents: _incidents,
            onTakeOwnership: _handleTakeOwnership,
            onTriage: (incident) {
              showDialog(
                context: context,
                builder: (ctx) => IncidentAiTriageDialog(
                  incident: incident,
                  onExecuteContainment: () => _handleExecuteContainment(incident),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
