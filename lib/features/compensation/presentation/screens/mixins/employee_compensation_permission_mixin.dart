import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin EmployeeCompensationPermissionMixin {
  bool get canCreateEmployeeCompensation =>
      PermissionService.instance.can(PermKeys.compensationEmployeeCompensationCreate);

  bool get canViewEmployeeCompensation => PermissionService.instance.can(PermKeys.compensationEmployeeCompensationView);
}
