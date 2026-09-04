import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/nav_item_ids.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/permissions/permission_visibility_mixin.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/gen/assets.gen.dart';

import 'dashboard_button_model.dart';

final _dashboardPermissionVisibility = _DashboardPermissionVisibility();

class _DashboardPermissionVisibility with PermissionVisibilityMixin {}

List<DashboardButton> getDashboardButtons(AppLocalizations loc) {
  final buttons = [
    DashboardButton(
      id: NavItemIds.dashboard,
      icon: Assets.icons.dashboardMainIcon.path,
      label: 'Dashboard',
      subtitle: 'Analytics & reports',
      color: AppColors.primaryLight,
      route: '/dashboard',
    ),
    DashboardButton(
      id: NavItemIds.enterpriseStructureButton,
      icon: Assets.icons.workforceStructureMainIcon.path,
      label: 'Enterprise Structure',
      subtitle: 'Workforce & hierarchy',
      color: AppColors.dashEnterpriseStructure,
      route: AppRoutes.enterpriseStructure,
    ),
    DashboardButton(
      id: NavItemIds.securityManager,
      icon: Assets.icons.securityIcon.path,
      label: 'Security Manager',
      subtitle: 'IAM posture & access controls',
      color: AppColors.dashManagerSS,
      route: AppRoutes.securityManager,
    ),
    DashboardButton(
      id: NavItemIds.grc,
      icon: Assets.icons.complianceMainIcon.path,
      label: 'Governance & GRC',
      subtitle: 'Frameworks & risk register',
      color: AppColors.dashCompliance,
      route: AppRoutes.grc,
    ),
    DashboardButton(
      id: NavItemIds.cyberSecurityButton,
      icon: Assets.icons.auth.secureShield.path,
      label: 'Cyber Security',
      subtitle: 'Threat detection & posture',
      color: AppColors.dashCyberSecurity,
      route: AppRoutes.cyberSecurity,
    ),
  ];

  return buttons
      .where(
        (button) => _dashboardPermissionVisibility.canAccessDashboardButtonId(
          button.id,
        ),
      )
      .toList();
}
