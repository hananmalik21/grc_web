import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin AdjustmentsPermissionMixin {
  bool get canCreateAdjustment => PermissionService.instance.can(PermKeys.compensationAdjustmentsCreate);

  bool get canViewAdjustment => PermissionService.instance.can(PermKeys.compensationAdjustmentsView);
}
