import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ShiftsPermissionMixin {
  bool get canCreateShift => PermissionService.instance.can(PermKeys.timeManagementShiftsCreate);

  bool get canViewShift => PermissionService.instance.can(PermKeys.timeManagementShiftsView);

  bool get canUpdateShift => PermissionService.instance.can(PermKeys.timeManagementShiftsUpdate);

  bool get canDeleteShift => PermissionService.instance.can(PermKeys.timeManagementShiftsDelete);
}
