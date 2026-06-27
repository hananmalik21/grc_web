import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ManageComponentValuesPermissionMixin {
  bool get canCreateComponentValue => PermissionService.instance.can(PermKeys.enterpriseComponentValuesCreate);

  bool get canViewComponentValue => PermissionService.instance.can(PermKeys.enterpriseComponentValuesView);

  bool get canUpdateComponentValue => PermissionService.instance.can(PermKeys.enterpriseComponentValuesUpdate);

  bool get canDeleteComponentValue => PermissionService.instance.can(PermKeys.enterpriseComponentValuesDelete);
}
