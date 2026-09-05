import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/threat_detection/threat_alert_model.dart';
import 'package:grc/core/permissions/permission_gate.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/models/threat_dto.dart';
import 'package:grc/features/cyber_security/presentation/providers/threat_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/widgets/threat_alerts_table.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/widgets/threat_detection_kpi_row.dart';

class ThreatDetectionScreen extends ConsumerWidget {
  const ThreatDetectionScreen({super.key});

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
      data: (items) => _buildLayout(context, ref, items.map(_toAlert).toList()),
    );
  }

  Widget _permissionDenied() => CyberScreenLayout(
    title: 'Threat Detection',
    subtitle: 'You do not have permission to view threat telemetry.',
    child: const SizedBox.shrink(),
  );

  ThreatAlertModel _toAlert(ThreatDto threat) {
    final status = switch (threat.status.toUpperCase()) {
      'INVESTIGATING' => ThreatStatus.investigating,
      'MITIGATED' || 'FALSE_POSITIVE' => ThreatStatus.closed,
      _ => ThreatStatus.new_,
    };
    final severity = switch (threat.severity.toUpperCase()) {
      'CRITICAL' => ThreatSeverity.critical,
      'HIGH' => ThreatSeverity.high,
      'MEDIUM' => ThreatSeverity.medium,
      _ => ThreatSeverity.low,
    };
    final source = switch (threat.threatType.toUpperCase()) {
      'ANOMALOUS_ACCESS' => ThreatSource.identity,
      'PRIVILEGE_ESCALATION' => ThreatSource.iam,
      'EXFILTRATION' => ThreatSource.data,
      'BOLA_ATTACK' => ThreatSource.appSec,
      _ => ThreatSource.cloud,
    };
    return ThreatAlertModel(
      alertId: threat.id,
      title: threat.title,
      severity: severity,
      source: source,
      timeAgo: threat.occurredAt?.toLocal().toString() ?? 'Recently',
      status: status,
      mitreTechnique: threat.mitreTechniqueId ?? 'Not available',
      description:
          threat.aiAnalysisSummary ??
          'Threat correlated from security telemetry.',
      affectedResource:
          threat.associatedActor ?? threat.associatedIp ?? 'Not available',
    );
  }

  Widget _buildLayout(
    BuildContext context,
    WidgetRef ref,
    List<ThreatAlertModel> alerts,
  ) {
    final newCount = alerts.where((a) => a.status == ThreatStatus.new_).length;
    final investigatingCount = alerts
        .where((a) => a.status == ThreatStatus.investigating)
        .length;
    final criticalCount = alerts
        .where((a) => a.severity == ThreatSeverity.critical)
        .length;

    return CyberScreenLayout(
      title: 'Threat Detection',
      subtitle:
          'Real-time telemetry, behavioral anomalies, and SIEM correlation',
      actions: [
        _ScreenActionButton(
          label: 'Filter',
          icon: Icons.filter_list_rounded,
          onTap: () => ToastService.show(
            context: context,
            message: 'Use the table filters to refine live threats.',
            type: ToastType.info,
          ),
        ),
        const Gap(8),
        _ScreenActionButton(
          label: 'Create Rule',
          icon: Icons.add_rounded,
          isPrimary: true,
          onTap: null,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThreatDetectionKpiRow(
            newAlertsCount: newCount,
            investigatingCount: investigatingCount,
            criticalTodayCount: criticalCount,
            detectionRulesCount: 0,
          ),
          const Gap(24),
          ThreatAlertsTable(
            alerts: alerts,
            onInvestigate: (alert) async {
              await ref
                  .read(threatRepositoryProvider)
                  .updateStatus(alert.alertId, 'INVESTIGATING');
              ref.invalidate(liveThreatsProvider);
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
