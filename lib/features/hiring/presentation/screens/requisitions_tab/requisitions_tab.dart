import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_filter_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_table_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/requisitions_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/requisitions_desktop_layout.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/requisitions_mobile_layout.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/requisitions_tablet_layout.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/create_requisition_mobile_sheet.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/create_requisition_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequisitionsTab extends ConsumerStatefulWidget {
  const RequisitionsTab({super.key});

  @override
  ConsumerState<RequisitionsTab> createState() => _RequisitionsTabState();
}

class _RequisitionsTabState extends ConsumerState<RequisitionsTab> with RequisitionsPermissionMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(requisitionsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(requisitionsFilterProvider.notifier).reset();
    ref.read(requisitionsShowFiltersProvider.notifier).state = false;
    ref.read(requisitionsTabRefreshTickProvider.notifier).state++;
  }

  void _onExportPressed(AppLocalizations localizations) {
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.requisitions(localizations));
  }

  void _onNewRequisitionPressed() {
    if (context.screenLayout.isMobile) {
      CreateRequisitionMobileSheet.show(context);
    } else {
      context.pushNamed(CreateRequisitionScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewRequisitions) {
      return const AppUnauthorizedState();
    }

    // Keeps [requisitionsPageProvider] subscribed while this tab is mounted.
    ref.watch(requisitionsPageProvider);

    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(requisitionsTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return RequisitionsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExportPressed: () => _onExportPressed(localizations),
        isExporting: isExporting,
        onNewRequisitionPressed: _onNewRequisitionPressed,
      );
    }

    if (layout.isTablet) {
      return RequisitionsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExportPressed: () => _onExportPressed(localizations),
        isExporting: isExporting,
        onNewRequisitionPressed: _onNewRequisitionPressed,
      );
    }

    return RequisitionsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onExportPressed: () => _onExportPressed(localizations),
      isExporting: isExporting,
      onNewRequisitionPressed: _onNewRequisitionPressed,
    );
  }
}
