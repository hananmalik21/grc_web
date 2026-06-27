import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin GradeStructurePermissionMixin {
  bool get canCreateGrade => PermissionService.instance.can(PermKeys.workforceGradeStructureCreate);

  bool get canViewGrade => PermissionService.instance.can(PermKeys.workforceGradeStructureView);

  bool get canUpdateGrade => PermissionService.instance.can(PermKeys.workforceGradeStructureUpdate);

  bool get canDeleteGrade => PermissionService.instance.can(PermKeys.workforceGradeStructureDelete);
}
