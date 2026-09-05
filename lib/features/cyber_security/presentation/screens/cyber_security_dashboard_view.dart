import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/models/cyber_security/dashboard/cyber_dashboard_models.dart';
import 'package:grc/core/permissions/permission_gate.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/features/auth/presentation/providers/auth_provider.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/cyber_security/data/mock/cyber_dashboard_mock_data.dart';
import 'package:grc/features/cyber_security/data/models/compliance_dto.dart';
import 'package:grc/features/cyber_security/presentation/providers/compliance_provider.dart';
import 'package:grc/features/cyber_security/presentation/providers/cyber_dashboard_provider.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_alert_volume_chart.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_compliance_bars.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_finding_severity_donut.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_recent_incidents_list.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_screen_layout.dart';

class CyberSecurityDashboardView extends ConsumerWidget {
  const CyberSecurityDashboardView({super.key});

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authProvider);
    if (!PermissionService.instance.can(CyberPermKeys.dashboardRead)) {
      return PermissionGate(
        permKey: CyberPermKeys.dashboardRead,
        fallback: _buildPermissionDenied(context),
        child: const SizedBox.shrink(),
      );
    }
    final dashboardAsync = ref.watch(cyberDashboardProvider);
    final frameworkCompliance =
        ref.watch(frameworkComplianceProvider).valueOrNull ??
        const <FrameworkComplianceItem>[];

    return CyberScreenLayout(
      title: 'Security Dashboard',
      subtitle: 'Real-time posture monitoring - 2026-06-28 16:41 UTC',
      actions: [
        // Live Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFF86EFAC),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6.r,
                height: 6.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
              ),
              const Gap(5),
              Text(
                'LIVE',
                style: TextStyle(
                  color: const Color(0xFF166534),
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
          icon: const Icon(
            Icons.refresh,
            size: 20,
            color: skyBlue,
          ),
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
          type: AppButtonType.primary,
          size: AppButtonSize.sm,
          backgroundColor: skyBlue,
          borderColor: skyBlue,
          height: 40.h,
          fontSize: 12.sp,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
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
        loading: () => _buildContent(context, null, frameworkCompliance),
        error: (error, stack) =>
            _buildContent(context, null, frameworkCompliance),
        data: (data) => _buildContent(context, data, frameworkCompliance),
      ),
    );
  }

  Widget _buildPermissionDenied(BuildContext context) {
    return CyberScreenLayout(
      title: 'Security Dashboard',
      subtitle: 'You do not have permission to view security telemetry.',
      child: const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    dynamic data,
    List<FrameworkComplianceItem> frameworkCompliance,
  ) {
    final kpis = data?.kpiCards ?? CyberDashboardMockData.kpiCards;
    final severityValues =
        data?.findingSeverityValues ??
        CyberDashboardMockData.findingSeverityValues;
    final severityColors =
        data?.findingSeverityColors ??
        CyberDashboardMockData.findingSeverityColors;
    final incidents =
        data?.recentIncidents ?? CyberDashboardMockData.recentIncidents;

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
                    Expanded(
                      child: CyberComplianceBars(
                        frameworks: frameworkCompliance,
                      ),
                    ),
                    const Gap(18),
                    Expanded(
                      child: CyberRecentIncidentsList(incidents: incidents),
                    ),
                  ],
                ),
              ),
            ] else if (isTablet) ...[
              const SizedBox(height: 320, child: CyberAlertVolumeChart()),
              const Gap(18),
              SizedBox(
                height: 320,
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
                    Expanded(
                      child: CyberComplianceBars(
                        frameworks: frameworkCompliance,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(18),
              SizedBox(
                height: 320,
                child: CyberRecentIncidentsList(incidents: incidents),
              ),
            ] else ...[
              // Mobile layout with increased heights to prevent overflow
              const SizedBox(height: 330, child: CyberAlertVolumeChart()),
              const Gap(16),
              SizedBox(
                height: 350,
                child: CyberFindingSeverityDonut(
                  values: severityValues,
                  colors: severityColors,
                ),
              ),
              const Gap(16),
              SizedBox(
                height: 320,
                child: CyberComplianceBars(frameworks: frameworkCompliance),
              ),
              const Gap(16),
              SizedBox(
                height: 320,
                child: CyberRecentIncidentsList(incidents: incidents),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildKpiGrid(double width, List<CyberKpiModel> kpis) {
    final badgeValues = ['7', '4', '73%', '2.8k'];

    return Wrap(
      spacing: 8.w,
      runSpacing: 10.h,
      children: List.generate(kpis.length, (index) {
        final card = kpis[index];
        // Calculate width: fit 4 on large screens, and exactly 2 on tablet/mobile screens.
        double cardWidth;
        if (width >= 1100) {
          cardWidth = (width - (3 * 8.w)) / 4;
        } else {
          cardWidth = (width - 8.w) / 2;
        }

        return SizedBox(
          width: cardWidth,
          child: CyberKpiCard(
            title: card.title,
            value: card.value,
            subtitle: card.subtitle,
            icon: card.icon,
            accentColor: index == 0 ? skyBlue : card.accentColor,
            subtitleColor: card.subtitleColor,
            isSelected: false, // Flat design requested
            badgeValue: badgeValues.length > index ? badgeValues[index] : card.value,
          ),
        );
      }),
    );
  }

}
