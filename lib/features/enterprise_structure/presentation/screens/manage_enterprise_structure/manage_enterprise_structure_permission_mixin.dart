import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ManageEnterpriseStructurePermissionMixin {
  bool get canCreateStructure => PermissionService.instance.can(PermKeys.enterpriseStructureManageCreate);

  bool get canViewStructure => PermissionService.instance.can(PermKeys.enterpriseStructureManageView);

  bool get canUpdateStructure => PermissionService.instance.can(PermKeys.enterpriseStructureManageUpdate);

  bool get canDeleteStructure => PermissionService.instance.can(PermKeys.enterpriseStructureManageDelete);

  bool get canActivateStructure => PermissionService.instance.can(PermKeys.enterpriseStructureManageActivate);
}
