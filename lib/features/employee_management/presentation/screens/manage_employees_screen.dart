import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/employee_management/presentation/providers/active_enterprise_org_structure_preload_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_dialog_flow_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_desktop_layout.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_mobile_layout.dart';
import 'package:grc/features/employee_management/presentation/screens/mixins/manage_employees_permission_mixin.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_tablet_layout.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_dialog.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageEmployeesScreen extends ConsumerStatefulWidget {
  const ManageEmployeesScreen({super.key});

  @override
  ConsumerState<ManageEmployeesScreen> createState() => _ManageEmployeesScreenState();
}

class _ManageEmployeesScreenState extends ConsumerState<ManageEmployeesScreen> with ManageEmployeesPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(manageEmployeesListProvider.notifier).reloadOnOpen();
    });
  }

  void _onEnterpriseChanged(int? id) =>
      ref.read(manageEmployeesSelectedEnterpriseProvider.notifier).setEnterpriseId(id);

  void _onAddEmployeePressed() {
    ref.read(addEmployeeDialogFlowProvider).clearForm();
    AddEmployeeDialog.show(context);
  }

  void _onAddEmployeeMobilePressed() => AddEmployeeMobileSheet.show(context);

  @override
  Widget build(BuildContext context) {
    ref.watch(activeEnterpriseOrgStructurePreloadProvider);

    final layout = context.screenLayout;

    if (!canViewEmployee) {
      return const AppUnauthorizedState();
    }

    if (layout.isMobile) {
      return ManageEmployeesMobileLayout(
        onAddEmployeePressed: _onAddEmployeeMobilePressed,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return ManageEmployeesTabletLayout(
        onAddEmployeePressed: _onAddEmployeePressed,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return ManageEmployeesDesktopLayout(
      onAddEmployeePressed: _onAddEmployeePressed,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
