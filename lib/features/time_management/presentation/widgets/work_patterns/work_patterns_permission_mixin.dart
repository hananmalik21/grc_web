import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin WorkPatternsPermissionMixin {
  bool get canCreateWorkPattern => PermissionService.instance.can(PermKeys.timeManagementWorkPatternsCreate);

  bool get canViewWorkPattern => PermissionService.instance.can(PermKeys.timeManagementWorkPatternsView);

  bool get canUpdateWorkPattern => PermissionService.instance.can(PermKeys.timeManagementWorkPatternsUpdate);

  bool get canDeleteWorkPattern => PermissionService.instance.can(PermKeys.timeManagementWorkPatternsDelete);
}
