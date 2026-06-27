import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin RolesManagementPermissionMixin {
  bool get canCreateRole => PermissionService.instance.can(PermKeys.securityRolesManagementCreate);

  bool get canViewRole => PermissionService.instance.can(PermKeys.securityRolesManagementView);

  bool get canUpdateRole => PermissionService.instance.can(PermKeys.securityRolesManagementUpdate);

  bool get canDeleteRole => PermissionService.instance.can(PermKeys.securityRolesManagementDelete);
}
