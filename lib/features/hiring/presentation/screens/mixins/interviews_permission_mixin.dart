import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin InterviewsPermissionMixin {
  bool get canViewInterviews => PermissionService.instance.can(PermKeys.hiringInterviewsView);

  bool get canCreateInterview => PermissionService.instance.can(PermKeys.hiringInterviewsCreate);

  bool get canUpdateInterview => PermissionService.instance.can(PermKeys.hiringInterviewsUpdate);
}
