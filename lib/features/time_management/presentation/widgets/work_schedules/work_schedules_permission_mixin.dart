import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin WorkSchedulesPermissionMixin {
  bool get canCreateWorkSchedule => PermissionService.instance.can(PermKeys.timeManagementWorkSchedulesCreate);

  bool get canViewWorkSchedule => PermissionService.instance.can(PermKeys.timeManagementWorkSchedulesView);

  bool get canUpdateWorkSchedule => PermissionService.instance.can(PermKeys.timeManagementWorkSchedulesUpdate);

  bool get canDeleteWorkSchedule => PermissionService.instance.can(PermKeys.timeManagementWorkSchedulesDelete);
}
