import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin RequisitionsPermissionMixin {
  bool get canViewRequisitions => PermissionService.instance.can(PermKeys.hiringRequisitionsView);

  bool get canCreateRequisition => PermissionService.instance.can(PermKeys.hiringRequisitionsCreate);

  bool get canUpdateRequisition => PermissionService.instance.can(PermKeys.hiringRequisitionsUpdate);
}
