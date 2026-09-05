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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
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
        _ScreenActionButton(
          label: 'Export CSV',
          icon: Icons.download_rounded,
          onTap: null, // As requested
        ),
        const Gap(8),
        _ScreenActionButton(
          label: 'Log Incident',
          icon: Icons.add_rounded,
          isPrimary: true,
          onTap: null, // As requested
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

class _ScreenActionButton extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isPrimary;

  const _ScreenActionButton({
    this.icon,
    required this.label,
    this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: isPrimary
                ? AppColors.dashCyberSecurity.withValues(alpha: 0.15)
                : const Color(0xFF1E293B).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isPrimary
                  ? AppColors.dashCyberSecurity.withValues(alpha: 0.5)
                  : const Color(0xFF334155),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 14.sp,
                  color: isPrimary ? AppColors.dashCyberSecurity : const Color(0xFFCBD5E1),
                ),
                const Gap(6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isPrimary ? AppColors.dashCyberSecurity : const Color(0xFFCBD5E1),
                  fontSize: 12.sp,
                  fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
