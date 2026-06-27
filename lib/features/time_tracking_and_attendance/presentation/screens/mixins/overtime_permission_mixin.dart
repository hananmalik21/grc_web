import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin OvertimePermissionMixin {
  bool get canCreateOvertime => PermissionService.instance.can(PermKeys.timeTrackingOvertimeCreate);

  bool get canViewOvertime => PermissionService.instance.can(PermKeys.timeTrackingOvertimeView);

  bool get canUpdateOvertime => PermissionService.instance.can(PermKeys.timeTrackingOvertimeUpdate);

  bool get canApproveOvertime => PermissionService.instance.can(PermKeys.timeTrackingOvertimeApproval);
}
