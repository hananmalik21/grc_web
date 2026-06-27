import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin PolicyConfigurationPermissionMixin {
  bool get canCreatePolicyConfiguration => PermissionService.instance.can(PermKeys.leavePolicyConfigurationCreate);

  bool get canViewPolicyConfiguration => PermissionService.instance.can(PermKeys.leavePolicyConfigurationView);

  bool get canUpdatePolicyConfiguration => PermissionService.instance.can(PermKeys.leavePolicyConfigurationUpdate);
}
