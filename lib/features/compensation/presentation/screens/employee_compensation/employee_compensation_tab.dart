import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/employee_compensation_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/employee_compensation_tab_enterprise_provider.dart';
import '../../providers/employees/employee_compensation_list_provider.dart';
import 'create_employee_compensation_plan_mobile_sheet.dart';
import 'create_employee_compensation_plan_page.dart';
import 'employee_compensation_desktop_layout.dart';
import 'employee_compensation_mobile_layout.dart';
import 'employee_compensation_tablet_layout.dart';

class EmployeeCompensationTab extends ConsumerStatefulWidget {
  const EmployeeCompensationTab({super.key});

  @override
  ConsumerState<EmployeeCompensationTab> createState() => _EmployeeCompensationTabState();
}

class _EmployeeCompensationTabState extends ConsumerState<EmployeeCompensationTab>
    with EmployeeCompensationPermissionMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(employeeCompensationListActionsProvider.notifier).loadInitial();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(compensationEmployeeTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(employeeCompensationListCurrentPageProvider.notifier).state = 1;
    ref.read(employeeCompensationListActionsProvider.notifier).loadInitial();
  }

  Future<void> _onCreatePressed() async {
    final layout = context.screenLayout;
    if (layout.isMobile || layout.isTabletSmall) {
      await CreateEmployeeCompensationPlanMobileSheet.show(context);
      return;
    }
    await context.pushNamed(CreateEmployeeCompensationPlanPage.routeName);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(compensationEmployeeTabEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(
          context,
          enterpriseId: enterpriseId,
          config: SpreadsheetExportConfigs.compEmployeeCompensation(localizations),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewEmployeeCompensation) {
      return const AppUnauthorizedState();
    }

    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(compensationEmployeeTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return EmployeeCompensationMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        searchController: _searchController,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return EmployeeCompensationTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        searchController: _searchController,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return EmployeeCompensationDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
      searchController: _searchController,
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
