import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin HrInterfacePermissionMixin {
  bool get canViewHrInterface => PermissionService.instance.can(PermKeys.hiringHrInterfaceView);

  bool get canUpdateHrInterface => PermissionService.instance.can(PermKeys.hiringHrInterfaceUpdate);
}
