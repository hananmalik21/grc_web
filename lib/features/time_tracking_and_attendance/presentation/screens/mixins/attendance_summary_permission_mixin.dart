import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin AttendanceSummaryPermissionMixin {
  bool get canViewAttendanceSummary => PermissionService.instance.can(PermKeys.timeTrackingAttendanceSummaryView);
}

