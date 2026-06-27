import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin SalaryStructurePermissionMixin {
  bool get canCreateSalaryStructure => PermissionService.instance.can(PermKeys.compensationSalaryStructuresCreate);

  bool get canViewSalaryStructure => PermissionService.instance.can(PermKeys.compensationSalaryStructuresView);

  bool get canUpdateSalaryStructure => PermissionService.instance.can(PermKeys.compensationSalaryStructuresUpdate);

  bool get canDeleteSalaryStructure => PermissionService.instance.can(PermKeys.compensationSalaryStructuresDelete);
}
