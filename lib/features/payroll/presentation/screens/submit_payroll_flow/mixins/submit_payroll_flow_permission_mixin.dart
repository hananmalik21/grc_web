import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin SubmitPayrollFlowPermissionMixin {
  bool get canViewSubmitPayrollFlow => PermissionService.instance.can(PermKeys.payrollSubmitPayrollFlowView);

  bool get canSubmitPayrollFlow => PermissionService.instance.can(PermKeys.payrollSubmitPayrollFlowCreate);
}
