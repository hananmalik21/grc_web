import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin BulkAdjustmentsPermissionMixin {
  bool get canViewBulkAdjustments => PermissionService.instance.can(PermKeys.compensationBulkAdjustmentsView);

  bool get canCreateBulkAdjustment => PermissionService.instance.can(PermKeys.compensationBulkAdjustmentsCreate);
}
