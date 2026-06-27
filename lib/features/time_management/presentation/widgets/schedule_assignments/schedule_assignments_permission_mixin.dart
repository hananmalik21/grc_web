import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ScheduleAssignmentsPermissionMixin {
  bool get canCreateScheduleAssignment =>
      PermissionService.instance.can(PermKeys.timeManagementScheduleAssignmentsCreate);

  bool get canViewScheduleAssignment => PermissionService.instance.can(PermKeys.timeManagementScheduleAssignmentsView);

  bool get canUpdateScheduleAssignment =>
      PermissionService.instance.can(PermKeys.timeManagementScheduleAssignmentsUpdate);

  bool get canDeleteScheduleAssignment =>
      PermissionService.instance.can(PermKeys.timeManagementScheduleAssignmentsDelete);
}
