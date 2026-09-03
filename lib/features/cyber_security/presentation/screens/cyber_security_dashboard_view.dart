import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
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
import 'package:grc/features/cyber_security/presentation/widgets/cyber_dashboard_header.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_finding_severity_donut.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_kpi_card.dart';
import 'package:grc/features/cyber_security/presentation/widgets/cyber_recent_incidents_list.dart';

class CyberSecurityDashboardView extends StatelessWidget {
  const CyberSecurityDashboardView({super.key});

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

    return SingleChildScrollView(
      // padding: padding.copyWith(bottom: 30.h),
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
        ),
        const Gap(8),
        IconButton(
          tooltip: 'Refresh Dashboard',
          icon: const Icon(
            Icons.refresh,
            size: 18,
            color: AppColors.dashCyberSecurity,
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
              const SizedBox(height: 310, child: CyberAlertVolumeChart()),
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
                height: 300,
                child: CyberRecentIncidentsList(incidents: incidents),
              ),
            ] else ...[
              // Mobile layout
              const SizedBox(height: 280, child: CyberAlertVolumeChart()),
              const Gap(16),
              SizedBox(
                height: 280,
                child: CyberFindingSeverityDonut(
                  values: severityValues,
                  colors: severityColors,
                ),
              ),
              const Gap(16),
              SizedBox(
                height: 280,
                child: CyberComplianceBars(frameworks: frameworkCompliance),
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
}
