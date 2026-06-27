import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin LeaveRequestPermissionMixin {
  bool get canCreateLeaveRequest => PermissionService.instance.can(PermKeys.leaveRequestsCreate);

  bool get canViewLeaveRequest => PermissionService.instance.can(PermKeys.leaveRequestsView);

  bool get canApproveLeaveRequest => PermissionService.instance.can(PermKeys.leaveRequestsApproval);

  bool get canUpdateLeaveRequest => PermissionService.instance.can(PermKeys.leaveRequestsUpdate);

  bool get canDeleteLeaveRequest => PermissionService.instance.can(PermKeys.leaveRequestsDelete);
}
