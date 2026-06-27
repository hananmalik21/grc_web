import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin LeavePoliciesPermissionMixin {
  bool get canViewLeavePolicies => PermissionService.instance.can(PermKeys.leavePoliciesView);
}
