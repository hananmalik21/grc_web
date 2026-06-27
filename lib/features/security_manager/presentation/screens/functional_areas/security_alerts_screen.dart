import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/security_manager/presentation/providers/security_alerts/security_alerts_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_alerts/security_alerts_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/security_alerts/security_alerts_activity_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/security_alerts/security_alerts_filters_bar.dart';
import 'package:grc/features/security_manager/presentation/widgets/security_alerts/security_alerts_stats_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityAlertsScreen extends ConsumerStatefulWidget {
  const SecurityAlertsScreen({super.key});

  @override
  ConsumerState<SecurityAlertsScreen> createState() => _SecurityAlertsScreenState();
}

class _SecurityAlertsScreenState extends ConsumerState<SecurityAlertsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.text = ref.read(securityAlertsProvider).query;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(securityAlertsProvider);
    final notifier = ref.read(securityAlertsProvider.notifier);
    final effectiveEnterpriseId = ref.watch(securityManagerEnterpriseIdProvider);
    final filteredAlerts = notifier.filteredAlerts;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: 'Security Alerts',
              description: 'Real-time security events and threat detection',
              trailing: AppButton.primary(
                label: 'Configure Alert',
                svgPath: Assets.icons.header.notificationBell.path,
                onPressed: () {},
              ),
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(securityManagerSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
            ),
            Gap(24.h),
            SecurityAlertsStatsCards(
              isDark: isDark,
              stats: [
                SecurityAlertStat(
                  title: 'Critical',
                  value: '6',
                  iconPath: Assets.icons.securityManager.securityAlerts.path,
                  badgeBackgroundColor: SecurityAlertLevel.critical.capsuleBackgroundColor(isDark: isDark),
                  iconColor: SecurityAlertLevel.critical.capsuleTextColor(isDark: isDark),
                ),
                SecurityAlertStat(
                  title: 'High',
                  value: '1',
                  iconPath: Assets.icons.warningIcon.path,
                  badgeBackgroundColor: SecurityAlertLevel.high.capsuleBackgroundColor(isDark: isDark),
                  iconColor: SecurityAlertLevel.high.capsuleTextColor(isDark: isDark),
                ),
                SecurityAlertStat(
                  title: 'Medium',
                  value: '0',
                  iconPath: Assets.icons.warningIcon.path,
                  badgeBackgroundColor: SecurityAlertLevel.medium.capsuleBackgroundColor(isDark: isDark),
                  iconColor: SecurityAlertLevel.medium.capsuleTextColor(isDark: isDark),
                ),
                SecurityAlertStat(
                  title: 'New Alerts',
                  value: '0',
                  iconPath: Assets.icons.header.notificationBell.path,
                  badgeBackgroundColor: SecurityAlertLevel.newAlert.capsuleBackgroundColor(isDark: isDark),
                  iconColor: SecurityAlertLevel.newAlert.capsuleTextColor(isDark: isDark),
                ),
                SecurityAlertStat(
                  title: 'Resolved',
                  value: '6',
                  iconPath: Assets.icons.checkCircleGreen.path,
                  badgeBackgroundColor: SecurityAlertLevel.resolved.capsuleBackgroundColor(isDark: isDark),
                  iconColor: SecurityAlertLevel.resolved.capsuleTextColor(isDark: isDark),
                ),
              ],
            ),
            Gap(24.h),
            SecurityAlertsFiltersBar(
              isDark: isDark,
              searchController: _searchController,
              levelValue: state.levelFilter.label,
              statusValue: state.statusFilter.label,
              levels: SecurityAlertLevel.values.map((value) => value.label).toList(),
              statuses: SecurityAlertStatus.values.map((value) => value.label).toList(),
              onSearchChanged: notifier.setQuery,
              onLevelChanged: (value) {
                if (value == null) return;
                notifier.setLevelFilter(
                  SecurityAlertLevel.values.firstWhere(
                    (level) => level.label == value,
                    orElse: () => SecurityAlertLevel.all,
                  ),
                );
              },
              onStatusChanged: (value) {
                if (value == null) return;
                notifier.setStatusFilter(
                  SecurityAlertStatus.values.firstWhere(
                    (status) => status.label == value,
                    orElse: () => SecurityAlertStatus.all,
                  ),
                );
              },
            ),
            Gap(20.h),
            SecurityAlertsActivitySection(isDark: isDark, alerts: filteredAlerts, onViewMatrix: () {}),
          ],
        ),
      ),
    );
  }
}
