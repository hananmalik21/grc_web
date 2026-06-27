import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin ReportingStructurePermissionMixin {
  bool get canViewReportingStructure => PermissionService.instance.can(PermKeys.workforceReportingStructureView);
}
