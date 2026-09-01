import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_alert_volume_chart.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_compliance_bars.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_dashboard_header.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_finding_severity_donut.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_recent_incidents_list.dart';

class CyberSecurityDashboardView extends StatelessWidget {
  const CyberSecurityDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveHelper.getPagePadding(context);

    return SingleChildScrollView(
      padding: padding.copyWith(bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const CyberDashboardHeader(),
          const Gap(20),

          // KPI Cards Row (4 cards in 1 row)
          _buildKpiGrid(),
          const Gap(18),

          // Row 1: Alert Volume & Finding Severity (2 cards in 1 line)
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoColumn = constraints.maxWidth >= 850;
              if (isTwoColumn) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: CyberAlertVolumeChart()),
                    Gap(18),
                    Expanded(child: CyberFindingSeverityDonut()),
                  ],
                );
              }
              return Column(
                children: const [
                  CyberAlertVolumeChart(),
                  Gap(18),
                  CyberFindingSeverityDonut(),
                ],
              );
            },
          ),
          const Gap(18),

          // Row 2: Framework Compliance & Recent Incidents (2 cards in 1 line)
          LayoutBuilder(
            builder: (context, constraints) {
              final isTwoColumn = constraints.maxWidth >= 850;
              if (isTwoColumn) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: CyberComplianceBars()),
                    Gap(18),
                    Expanded(child: CyberRecentIncidentsList()),
                  ],
                );
              }
              return Column(
                children: const [
                  CyberComplianceBars(),
                  Gap(18),
                  CyberRecentIncidentsList(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid() {
    final kpis = [
      const CyberKpiCard(
        title: 'OPEN FINDINGS',
        value: '312',
        subtitle: '4 critical need action',
        subtitleColor: Color(0xFF64748B),
        icon: Icons.warning_amber_rounded,
        accentColor: Color(0xFFF59E0B),
      ),
      const CyberKpiCard(
        title: 'ACTIVE INCIDENTS',
        value: '4',
        subtitle: '2 unassigned',
        subtitleColor: Color(0xFF64748B),
        icon: Icons.error_outline_rounded,
        accentColor: Color(0xFFEF4444),
      ),
      const CyberKpiCard(
        title: 'POSTURE SCORE',
        value: '73%',
        subtitle: '+2% from last month',
        subtitleColor: Color(0xFF10B981),
        icon: Icons.shield_outlined,
        accentColor: Color(0xFF10B981),
      ),
      const CyberKpiCard(
        title: 'PROTECTED ASSETS',
        value: '2,847',
        subtitle: 'Across 3 cloud platforms',
        subtitleColor: Color(0xFF64748B),
        icon: Icons.dns_outlined,
        accentColor: Color(0xFF00BCD4),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isRowLayout = constraints.maxWidth >= 700;

        if (isRowLayout) {
          return Row(
            children: kpis
                .map(
                  (card) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: card,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: kpis[0]),
                const Gap(8),
                Expanded(child: kpis[1]),
              ],
            ),
            const Gap(8),
            Row(
              children: [
                Expanded(child: kpis[2]),
                const Gap(8),
                Expanded(child: kpis[3]),
              ],
            ),
          ],
        );
      },
    );
  }
}
