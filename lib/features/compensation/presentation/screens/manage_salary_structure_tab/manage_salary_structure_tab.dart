import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_listing_provider.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/create_salary_structure_mobile_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_desktop_layout.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_mobile_layout.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_tablet_layout.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/create_salary_strcuture.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/salary_structure_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ManageSalaryStructureTab extends ConsumerStatefulWidget {
  const ManageSalaryStructureTab({super.key});

  @override
  ConsumerState<ManageSalaryStructureTab> createState() => _ManageSalaryStructureTabState();
}

class _ManageSalaryStructureTabState extends ConsumerState<ManageSalaryStructureTab>
    with SalaryStructurePermissionMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
      ref.invalidate(salaryStructuresPageProvider);
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(manageSalaryStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
    ref.read(salaryStructuresRefreshTickProvider.notifier).state += 1;
  }

  Future<void> _onCreatePressed() async {
    final bool created;
    if (context.isMobileLayout) {
      created = await CreateSalaryStructureMobileSheet.show(context);
    } else {
      created = await context.pushNamed<bool>(SalaryStructureCreationScreen.routeName) == true;
    }
    if (!created) return;

    ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
    ref.read(salaryStructuresRefreshTickProvider.notifier).state += 1;
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(manageSalaryStructureEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(
          context,
          enterpriseId: enterpriseId,
          config: SpreadsheetExportConfigs.compSalaryStructuresDetails(localizations),
        );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(manageSalaryStructureEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;
    if (!canViewSalaryStructure) return AppUnauthorizedState();

    if (layout.isMobile) {
      return ManageSalaryStructureMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return ManageSalaryStructureTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return ManageSalaryStructureDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
