import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/screens/reporting_structure/reporting_structure_desktop_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/reporting_structure/reporting_structure_mobile_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/reporting_structure/reporting_structure_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/screens/reporting_structure/reporting_structure_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportingStructureTab extends ConsumerStatefulWidget {
  const ReportingStructureTab({super.key});

  @override
  ConsumerState<ReportingStructureTab> createState() => _ReportingStructureTabState();
}

class _ReportingStructureTabState extends ConsumerState<ReportingStructureTab> with ReportingStructurePermissionMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(reportingStructureNotifierProvider.notifier).refresh());
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(reportingStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(reportingStructureEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(
          context,
          enterpriseId: enterpriseId,
          config: SpreadsheetExportConfigs.reportingStructure(localizations),
        );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(reportingStructureEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (!canViewReportingStructure) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return ReportingStructureMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return ReportingStructureTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return ReportingStructureDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
