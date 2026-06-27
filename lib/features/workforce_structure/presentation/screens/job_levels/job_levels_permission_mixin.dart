import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin JobLevelsPermissionMixin {
  bool get canCreateJobLevel => PermissionService.instance.can(PermKeys.workforceJobLevelsCreate);

  bool get canViewJobLevel => PermissionService.instance.can(PermKeys.workforceJobLevelsView);

  bool get canUpdateJobLevel => PermissionService.instance.can(PermKeys.workforceJobLevelsUpdate);

  bool get canDeleteJobLevel => PermissionService.instance.can(PermKeys.workforceJobLevelsDelete);
}
