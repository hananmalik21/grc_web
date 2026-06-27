import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin JobFamiliesPermissionMixin {
  bool get canCreateJobFamily => PermissionService.instance.can(PermKeys.workforceJobFamiliesCreate);

  bool get canViewJobFamily => PermissionService.instance.can(PermKeys.workforceJobFamiliesView);

  bool get canUpdateJobFamily => PermissionService.instance.can(PermKeys.workforceJobFamiliesUpdate);

  bool get canDeleteJobFamily => PermissionService.instance.can(PermKeys.workforceJobFamiliesDelete);
}
