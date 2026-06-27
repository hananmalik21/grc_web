import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/gen/assets.gen.dart';

/// Static configuration for the Application Roles stats row cards.
///
/// Values (counts) are injected at build time from the provider state.
List<RolesManagementStatsCardData> buildApplicationRolesStatsCards({
  required int totalRoles,
  required int activeRoles,
  required int usersAssigned,
  required int systemRoles,
}) {
  return [
    RolesManagementStatsCardData(
      title: 'Total Roles',
      value: totalRoles.toString(),
      subtitle: 'Application roles defined',
      iconPath: Assets.icons.securityManager.applicationRoles.path,
    ),
    RolesManagementStatsCardData(
      title: 'Active Roles',
      value: activeRoles.toString(),
      subtitle: 'Currently active',
      iconPath: Assets.icons.checkIconGreen.path,
    ),
    RolesManagementStatsCardData(
      title: 'Users Assigned',
      value: usersAssigned.toString(),
      subtitle: 'Across all roles',
      iconPath: Assets.icons.employeeListIcon.path,
    ),
    RolesManagementStatsCardData(
      title: 'System Roles',
      value: systemRoles.toString(),
      subtitle: 'Built-in roles',
      iconPath: Assets.icons.securityIcon.path,
    ),
  ];
}
