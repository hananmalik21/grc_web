import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';

mixin FlowMonitorPermissionMixin {
  bool get canViewFlowMonitor => PermissionService.instance.can(PermKeys.payrollFlowMonitorView);

  bool get canProcessFlowMonitorTasks => PermissionService.instance.can(PermKeys.payrollFlowMonitorCreate);

  bool get canUpdateFlowMonitorTasks => PermissionService.instance.can(PermKeys.payrollFlowMonitorUpdate);
}
