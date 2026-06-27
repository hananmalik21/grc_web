import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ComponentsPermissionMixin {
  bool get canCreateComponent => PermissionService.instance.can(PermKeys.compensationComponentsCreate);

  bool get canViewComponent => PermissionService.instance.can(PermKeys.compensationComponentsView);

  bool get canUpdateComponent => PermissionService.instance.can(PermKeys.compensationComponentsUpdate);

  bool get canDeleteComponent => PermissionService.instance.can(PermKeys.compensationComponentsDelete);
}
