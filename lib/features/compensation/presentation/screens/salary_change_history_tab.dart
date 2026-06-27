import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/compensation/presentation/screens/salary_change_history/salary_change_history_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/responsive_service.dart';
import '../providers/salary_change_history_filter_provider.dart';
import '../providers/salary_change_history_tab_enterprise_provider.dart';
import '../providers/salary_change_history_tab_provider.dart';
import 'salary_change_history/salary_change_history_desktop_layout.dart';
import 'salary_change_history/salary_change_history_mobile_layout.dart';
import 'salary_change_history/salary_change_history_tablet_layout.dart';

class SalaryChangeHistoryTab extends ConsumerStatefulWidget {
  const SalaryChangeHistoryTab({super.key});

  @override
  ConsumerState<SalaryChangeHistoryTab> createState() => _SalaryChangeHistoryTabState();
}

class _SalaryChangeHistoryTabState extends ConsumerState<SalaryChangeHistoryTab>
    with SalaryChangeHistoryPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salaryChangeHistoryDataPageProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final layout = context.screenLayout;
    final selectedEnterpriseId = ref.watch(salaryChangeHistoryTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);

    void onEnterpriseChanged(int? enterpriseId) {
      ref.read(salaryChangeHistoryTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    }

    void onSearchChanged(String query) {
      ref.read(salaryChangeHistoryFilterProvider.notifier).setSearch(query);
    }

    void onExport() {
      final enterpriseId = ref.read(salaryChangeHistoryTabEnterpriseIdProvider);
      ref
          .read(spreadsheetExportProvider.notifier)
          .export(
            context,
            enterpriseId: enterpriseId,
            config: SpreadsheetExportConfigs.compensationSalaryChangeHistory(localizations),
          );
    }

    if (!canViewSalaryChangeHistory) return AppUnauthorizedState();

    if (layout.isMobile) {
      return SalaryChangeHistoryMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
        onSearchChanged: onSearchChanged,
        onExport: onExport,
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return SalaryChangeHistoryTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
        onSearchChanged: onSearchChanged,
        onExport: onExport,
        isExporting: isExporting,
      );
    }

    return SalaryChangeHistoryDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: onEnterpriseChanged,
      onSearchChanged: onSearchChanged,
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
