import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ManageEmployeesPermissionMixin {
  bool get canCreateEmployee => PermissionService.instance.can(PermKeys.manageEmployeesCreate);

  bool get canViewEmployee => PermissionService.instance.can(PermKeys.manageEmployeesView);

  bool get canUpdateEmployee => PermissionService.instance.can(PermKeys.manageEmployeesUpdate);

  bool get canDeleteEmployee => PermissionService.instance.can(PermKeys.manageEmployeesDelete);
}
