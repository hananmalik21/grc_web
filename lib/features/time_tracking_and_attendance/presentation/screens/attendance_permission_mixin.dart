import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin AttendancePermissionMixin {
  bool get canCreateAttendance => PermissionService.instance.can(PermKeys.timeTrackingAttendanceCreate);

  bool get canViewAttendance => PermissionService.instance.can(PermKeys.timeTrackingAttendanceView);

  bool get canUpdateAttendance => PermissionService.instance.can(PermKeys.timeTrackingAttendanceUpdate);
}
