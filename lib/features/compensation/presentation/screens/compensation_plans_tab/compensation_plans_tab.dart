import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/compensation_plans_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import '../../providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import '../../providers/compensation_plans/compensation_plans_table_selection_provider.dart';
import '../compensation_plans/compensation_plans_desktop_layout.dart';
import '../compensation_plans/compensation_plans_mobile_layout.dart';
import '../compensation_plans/compensation_plans_tablet_layout.dart';
import 'create_compensation_plan_mobile_sheet.dart';
import 'create_compensation_plan_screen.dart';

class CompensationPlansTab extends ConsumerStatefulWidget {
  const CompensationPlansTab({super.key});

  @override
  ConsumerState<CompensationPlansTab> createState() => _CompensationPlansTabState();
}

class _CompensationPlansTabState extends ConsumerState<CompensationPlansTab> with CompensationPlansPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(compensationPlansTableSelectionProvider.notifier).clear();
      ref.read(compensationPlansCurrentPageProvider.notifier).state = 1;
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(compensationPlansTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(compensationPlansTableSelectionProvider.notifier).clear();
    ref.read(compensationPlansCurrentPageProvider.notifier).state = 1;
  }

  Future<void> _onCreatePlanPressed() async {
    final bool created;
    if (context.isMobileLayout) {
      created = await CreateCompensationPlanMobileSheet.show(context);
    } else {
      created = await context.pushNamed<bool>(CreateCompensationPlanScreen.routeName) == true;
    }
    if (!created) return;

    ref.invalidate(compensationPlansPageProvider);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(compensationPlansTabEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.compPlansDetails(localizations));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(compensationPlansTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;
    if (!canViewCompensationPlan) return AppUnauthorizedState();

    if (layout.isMobile) {
      return CompensationPlansMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePlanPressed: _onCreatePlanPressed,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return CompensationPlansTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePlanPressed: _onCreatePlanPressed,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return CompensationPlansDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePlanPressed: _onCreatePlanPressed,
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
