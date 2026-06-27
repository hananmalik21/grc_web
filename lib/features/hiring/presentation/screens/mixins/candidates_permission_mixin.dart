import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin CandidatesPermissionMixin {
  bool get canViewCandidates => PermissionService.instance.can(PermKeys.hiringCandidatesView);

  bool get canCreateCandidate => PermissionService.instance.can(PermKeys.hiringCandidatesCreate);

  bool get canUpdateCandidate => PermissionService.instance.can(PermKeys.hiringCandidatesUpdate);
}
