import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin PublicHolidaysPermissionMixin {
  bool get canCreatePublicHoliday => PermissionService.instance.can(PermKeys.timeManagementPublicHolidaysCreate);

  bool get canViewPublicHoliday => PermissionService.instance.can(PermKeys.timeManagementPublicHolidaysView);

  bool get canUpdatePublicHoliday => PermissionService.instance.can(PermKeys.timeManagementPublicHolidaysUpdate);

  bool get canDeletePublicHoliday => PermissionService.instance.can(PermKeys.timeManagementPublicHolidaysDelete);
}
