import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin PersonResultsPermissionMixin {
  bool get canViewPersonResults => PermissionService.instance.can(PermKeys.payrollPersonResultsView);
}
