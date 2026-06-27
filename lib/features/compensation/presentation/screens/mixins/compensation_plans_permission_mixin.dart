import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin CompensationPlansPermissionMixin {
  bool get canCreateCompensationPlan => PermissionService.instance.can(PermKeys.compensationPlansCreate);

  bool get canViewCompensationPlan => PermissionService.instance.can(PermKeys.compensationPlansView);

  bool get canUpdateCompensationPlan => PermissionService.instance.can(PermKeys.compensationPlansUpdate);

  bool get canDeleteCompensationPlan => PermissionService.instance.can(PermKeys.compensationPlansDelete);
}
