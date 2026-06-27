import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin OvertimeConfigurationPermissionMixin {
  bool get canCreateOvertimeConfiguration =>
      PermissionService.instance.can(PermKeys.timeTrackingOvertimeConfigurationCreate);

  bool get canViewOvertimeConfiguration =>
      PermissionService.instance.can(PermKeys.timeTrackingOvertimeConfigurationView);

  bool get canUpdateOvertimeConfiguration =>
      PermissionService.instance.can(PermKeys.timeTrackingOvertimeConfigurationUpdate);
}
