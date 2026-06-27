import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ApplicationsPermissionMixin {
  bool get canViewApplications => PermissionService.instance.can(PermKeys.hiringApplicationsView);

  bool get canCreateApplication => PermissionService.instance.can(PermKeys.hiringApplicationsCreate);

  bool get canUpdateApplication => PermissionService.instance.can(PermKeys.hiringApplicationsUpdate);
}
