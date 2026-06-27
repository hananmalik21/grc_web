import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin AllLeaveBalancesPermissionMixin {
  bool get canViewLeaveBalance => PermissionService.instance.can(PermKeys.leaveBalanceView);

  bool get canUpdateLeaveBalance => PermissionService.instance.can(PermKeys.leaveBalanceUpdate);
}
