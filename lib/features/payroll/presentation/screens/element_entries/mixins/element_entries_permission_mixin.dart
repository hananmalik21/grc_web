import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ElementEntriesPermissionMixin {
  bool get canViewElementEntries => PermissionService.instance.can(PermKeys.payrollElementMappingView);

  bool get canCreateElementEntry => PermissionService.instance.can(PermKeys.payrollElementMappingCreate);

  bool get canUpdateElementEntries => PermissionService.instance.can(PermKeys.payrollElementMappingUpdate);
}
