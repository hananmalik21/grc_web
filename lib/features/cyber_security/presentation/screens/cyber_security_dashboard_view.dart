import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_dashboard_mock_data.dart';
import 'package:grc/features/cyber_security/presentation/providers/cyber_dashboard_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_alert_volume_chart.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_compliance_bars.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_finding_severity_donut.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_recent_incidents_list.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';

class CyberSecurityDashboardView extends ConsumerWidget {
  const CyberSecurityDashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(cyberDashboardProvider);

    return CyberScreenLayout(
      title: 'Security Dashboard',
      subtitle: 'Real-time posture monitoring - 2026-06-28 16:41 UTC',
      actions: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.cyberLiveGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.cyberLiveGreen.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: const BoxDecoration(
                  color: AppColors.cyberLiveGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(5),
              Text(
                'LIVE',
                style: TextStyle(
                  color: AppColors.cyberLiveGreen,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        IconButton(
          tooltip: 'Refresh Dashboard',
          icon: const Icon(Icons.refresh, size: 18, color: AppColors.dashCyberSecurity),
          onPressed: () {
            ref.read(cyberDashboardProvider.notifier).refresh();
            ToastService.show(
              context: context,
              message: 'Refreshing security metrics...',
              type: ToastType.info,
            );
          },
        ),
        const Gap(4),
        AppButton(
          label: 'Export',
          type: AppButtonType.secondary,
          size: AppButtonSize.sm,
          onPressed: () {
            ToastService.show(
              context: context,
              message: 'Executive security posture report exported.',
              type: ToastType.success,
            );
          },
        ),
      ],
      child: dashboardAsync.when(
        loading: () => _buildContent(context, null),
        error: (error, stack) => _buildContent(context, null),
        data: (data) => _buildContent(context, data),
      ),
    );
  }

  Widget _buildContent(BuildContext context, dynamic data) {
    final kpis = data?.kpiCards ?? CyberDashboardMockData.kpiCards;
    final severityValues = data?.findingSeverityValues ?? CyberDashboardMockData.findingSeverityValues;
    final severityColors = data?.findingSeverityColors ?? CyberDashboardMockData.findingSeverityColors;
    final incidents = data?.recentIncidents ?? CyberDashboardMockData.recentIncidents;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isDesktop = width >= 1100;
        final isTablet = width >= 700 && width < 1100;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildKpiGrid(width, kpis),
            const Gap(18),
            if (isDesktop) ...[
              SizedBox(
                height: 330,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(flex: 3, child: CyberAlertVolumeChart()),
                    const Gap(18),
                    Expanded(
                      flex: 2,
                      child: CyberFindingSeverityDonut(
                        values: severityValues,
                        colors: severityColors,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(18),
              SizedBox(
                height: 320,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Expanded(child: CyberComplianceBars()),
                    const Gap(18),
                    Expanded(
                      child: CyberRecentIncidentsList(incidents: incidents),
                    ),
                  ],
                ),
              ),
            ] else if (isTablet) ...[
              const SizedBox(
                height: 310,
                child: CyberAlertVolumeChart(),
              ),
              const Gap(18),
              SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CyberFindingSeverityDonut(
                        values: severityValues,
                        colors: severityColors,
                      ),
                    ),
                    const Gap(18),
                    const Expanded(child: CyberComplianceBars()),
                  ],
                ),
              ),
              const Gap(18),
              SizedBox(
                height: 300,
                child: CyberRecentIncidentsList(incidents: incidents),
              ),
            ] else ...[
              // Mobile layout
              const SizedBox(
                height: 280,
                child: CyberAlertVolumeChart(),
              ),
              const Gap(16),
              SizedBox(
                height: 280,
                child: CyberFindingSeverityDonut(
                  values: severityValues,
                  colors: severityColors,
                ),
              ),
              const Gap(16),
              const SizedBox(
                height: 280,
                child: CyberComplianceBars(),
              ),
              const Gap(16),
              SizedBox(
                height: 300,
                child: CyberRecentIncidentsList(incidents: incidents),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildKpiGrid(double width, List<CyberKpiModel> kpis) {
    final isDesktop = width >= 1100;

    if (isDesktop) {
      // 4 cards in one row on Desktop
      return Row(
        children: kpis
            .map(
              (card) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CyberKpiCard(
                    title: card.title,
                    value: card.value,
                    subtitle: card.subtitle,
                    icon: card.icon,
                    accentColor: card.accentColor,
                    subtitleColor: card.subtitleColor,
                  ),
                ),
              ),
            )
            .toList(),
      );
    }

    // Tablet and Mobile (2x2 grid: 2 cards in 1 row)
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CyberKpiCard(
                title: kpis[0].title,
                value: kpis[0].value,
                subtitle: kpis[0].subtitle,
                icon: kpis[0].icon,
                accentColor: kpis[0].accentColor,
                subtitleColor: kpis[0].subtitleColor,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: CyberKpiCard(
                title: kpis[1].title,
                value: kpis[1].value,
                subtitle: kpis[1].subtitle,
                icon: kpis[1].icon,
                accentColor: kpis[1].accentColor,
                subtitleColor: kpis[1].subtitleColor,
              ),
            ),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: CyberKpiCard(
                title: kpis[2].title,
                value: kpis[2].value,
                subtitle: kpis[2].subtitle,
                icon: kpis[2].icon,
                accentColor: kpis[2].accentColor,
                subtitleColor: kpis[2].subtitleColor,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: CyberKpiCard(
                title: kpis[3].title,
                value: kpis[3].value,
                subtitle: kpis[3].subtitle,
                icon: kpis[3].icon,
                accentColor: kpis[3].accentColor,
                subtitleColor: kpis[3].subtitleColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
