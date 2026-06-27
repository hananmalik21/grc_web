import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/breadcrumb_nav_extra.dart';
import '../../../../core/services/responsive_service.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/common/digify_breadcrumb.dart';
import '../providers/security_manager_tab_state_provider.dart';
import 'functional_areas/access_management_screen.dart';
import 'functional_areas/active_sessions_screen.dart';
import 'functional_areas/data_classification_screen.dart';
import 'functional_areas/role_delegation_screen.dart';
import 'functional_areas/roles_management_screen.dart';
import 'functional_areas/security_alerts_screen.dart';
import 'functional_areas/security_policies_screen.dart';
import 'functional_areas/segregation_of_duties_screen.dart';
import 'security_overview_screen.dart';
import 'user_management/user_management_screen.dart';

class _SecurityManagerTabIndex {
  static const int securityOverview = 0;
  static const int userManagement = 1;
  static const int accessManagement = 2;
  static const int rolesManagement = 3;
  static const int securityPolicies = 4;
  static const int activeSessions = 5;
  static const int securityAlerts = 6;
  static const int dataClassification = 7;
  static const int roleDelegation = 8;
  static const int segregationOfDuties = 9;
}

class SecurityManagerScreen extends ConsumerWidget {
  const SecurityManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final currentTabIndex = ref.watch(securityManagerTabStateProvider.select((s) => s.currentTabIndex));
    final isMobile = ResponsiveHelper.isMobile(context);
    final localizations = AppLocalizations.of(context)!;
    final extra = GoRouterState.of(context).extra;
    final BreadcrumbNavExtra? navExtra = extra is BreadcrumbNavExtra ? extra : null;
    final moduleSelectionRoute = navExtra?.returnTo ?? AppRoutes.dashboardModuleSelectionPath('securityManager');
    final moduleSelectionLabel = navExtra?.returnLabel ?? 'Module Selection';
    final childLabel = navExtra?.leafLabel ?? _childLabelForTabIndex(localizations, currentTabIndex);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: ResponsiveHelper.getPagePadding(context),
            child: isMobile
                ? null
                : DigifyBreadcrumb(
                    items: [
                      DigifyBreadcrumbItem(label: 'Dashboard', onTap: () => context.go(AppRoutes.dashboard)),
                      DigifyBreadcrumbItem(label: localizations.securityConsole),
                      DigifyBreadcrumbItem(label: moduleSelectionLabel, onTap: () => context.go(moduleSelectionRoute)),
                      DigifyBreadcrumbItem(label: childLabel),
                    ],
                  ),
          ),
          if (!isMobile) Gap(24.h),
          Expanded(child: _buildTabContent(context, currentTabIndex)),
        ],
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, int tabIndex) {
    switch (tabIndex) {
      case _SecurityManagerTabIndex.securityOverview:
        return const SecurityOverviewScreen();
      case _SecurityManagerTabIndex.userManagement:
        return const UserManagementScreen();
      case _SecurityManagerTabIndex.accessManagement:
        return const AccessManagementScreen();
      case _SecurityManagerTabIndex.rolesManagement:
        return const RolesManagementScreen();
      case _SecurityManagerTabIndex.securityPolicies:
        return const SecurityPoliciesScreen();
      case _SecurityManagerTabIndex.activeSessions:
        return const ActiveSessionsScreen();
      case _SecurityManagerTabIndex.securityAlerts:
        return const SecurityAlertsScreen();
      case _SecurityManagerTabIndex.dataClassification:
        return const DataClassificationScreen();
      case _SecurityManagerTabIndex.roleDelegation:
        return const RoleDelegationScreen();
      case _SecurityManagerTabIndex.segregationOfDuties:
        return const SegregationOfDutiesScreen();
      default:
        return const SecurityOverviewScreen();
    }
  }

  String _childLabelForTabIndex(AppLocalizations localizations, int tabIndex) {
    switch (tabIndex) {
      case _SecurityManagerTabIndex.securityOverview:
        return localizations.securityConsoleOverview;
      case _SecurityManagerTabIndex.userManagement:
        return 'User Management';
      case _SecurityManagerTabIndex.accessManagement:
        return 'Access Management';
      case _SecurityManagerTabIndex.rolesManagement:
        return 'Roles Management';
      case _SecurityManagerTabIndex.securityPolicies:
        return 'Security Policies';
      case _SecurityManagerTabIndex.activeSessions:
        return 'Active Sessions';
      case _SecurityManagerTabIndex.securityAlerts:
        return 'Security Alerts';
      case _SecurityManagerTabIndex.dataClassification:
        return 'Data Classification';
      case _SecurityManagerTabIndex.roleDelegation:
        return 'Role Delegation';
      case _SecurityManagerTabIndex.segregationOfDuties:
        return 'Segregation of Duties';
      default:
        return localizations.securityConsoleOverview;
    }
  }
}
