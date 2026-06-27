import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin TimesheetPermissionMixin {
  bool get canCreateTimesheet => PermissionService.instance.can(PermKeys.timeTrackingTimesheetsCreate);

  bool get canViewTimesheet => PermissionService.instance.can(PermKeys.timeTrackingTimesheetsView);

  bool get canApproveTimesheet => PermissionService.instance.can(PermKeys.timeTrackingTimesheetsApproval);

  bool get canUpdateTimesheet => PermissionService.instance.can(PermKeys.timeTrackingTimesheetsUpdate);
}
