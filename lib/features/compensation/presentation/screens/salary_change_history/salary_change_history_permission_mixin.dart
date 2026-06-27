import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin SalaryChangeHistoryPermissionMixin {
  bool get canViewSalaryChangeHistory => PermissionService.instance.can(PermKeys.compensationSalaryChangeHistoryView);
}
