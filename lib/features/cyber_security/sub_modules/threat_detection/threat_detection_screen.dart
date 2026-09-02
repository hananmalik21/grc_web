import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/dialogs/create_detection_rule_dialog.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/models/threat_alert_model.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/widgets/threat_alerts_table.dart';
import 'package:grc/features/cyber_security/sub_modules/threat_detection/widgets/threat_detection_kpi_row.dart';

class ThreatDetectionScreen extends StatefulWidget {
  const ThreatDetectionScreen({super.key});

  @override
  State<ThreatDetectionScreen> createState() => _ThreatDetectionScreenState();
}

class _ThreatDetectionScreenState extends State<ThreatDetectionScreen> {
  final List<ThreatAlertModel> _alerts = ThreatAlertModel.getMockThreatAlerts();

  void _openCreateRuleDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const CreateDetectionRuleDialog(),
    );
  }

  void _openFilterDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF131D31),
        content: Text(
          'Filtering applied: Showing high & critical severity telemetry across all layers.',
          style: TextStyle(color: Color(0xFF00B4D8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final padding = ResponsiveHelper.getPagePadding(context);

    final newCount = _alerts.where((a) => a.status == ThreatStatus.new_).length;
    final investigatingCount =
        _alerts.where((a) => a.status == ThreatStatus.investigating).length;
    final criticalCount =
        _alerts.where((a) => a.severity == ThreatSeverity.critical).length;

    final titleSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Threat Detection',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18.sp : 22.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(4),
        Text(
          'Real-time alerts from AI detection rules across all security layers',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: isMobile ? 11.sp : 12.sp,
          ),
        ),
      ],
    );

    final actionsSection = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // + New Rule Button
        InkWell(
          onTap: _openCreateRuleDialog,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 14.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                const Gap(6),
                Text(
                  'New Rule',
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(10),

        // Filter Button
        InkWell(
          onTap: _openFilterDialog,
          borderRadius: BorderRadius.circular(6.r),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 8.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF131D31),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  size: 14.sp,
                  color: const Color(0xFFCBD5E1),
                ),
                const Gap(6),
                Text(
                  'Filter',
                  style: TextStyle(
                    color: const Color(0xFFCBD5E1),
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      padding: padding.copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          if (isMobile) ...[
            titleSection,
            const Gap(12),
            actionsSection,
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: titleSection),
                actionsSection,
              ],
            ),
          ],
          const Gap(20),

          // 4 KPI Cards
          ThreatDetectionKpiRow(
            newAlertsCount: newCount,
            investigatingCount: investigatingCount,
            criticalTodayCount: criticalCount,
            detectionRulesCount: 247,
          ),
          const Gap(24),

          // Alerts Table with Tabs
          ThreatAlertsTable(
            alerts: _alerts,
          ),
        ],
      ),
    );
  }
}
