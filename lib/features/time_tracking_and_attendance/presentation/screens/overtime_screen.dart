import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_overtime_request_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_desktop_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_mobile_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/overtime/overtime_enterprise_provider.dart';
import '../providers/overtime/overtime_provider.dart';

class OvertimeScreen extends ConsumerStatefulWidget {
  const OvertimeScreen({super.key});

  @override
  ConsumerState<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends ConsumerState<OvertimeScreen> with OvertimePermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final enterpriseId = ref.read(overtimeEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(overtimeManagementProvider.notifier).setCompanyId(enterpriseId.toString());
      }
      ref.read(overtimeManagementProvider.notifier).loadOvertime();
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(overtimeSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(overtimeEnterpriseIdProvider);
    final selectedStatus = ref.read(overtimeManagementProvider).selectedStatus;
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(
          context,
          enterpriseId: enterpriseId,
          config: SpreadsheetExportConfigs.overtimeRequests(localizations, status: selectedStatus?.apiValue),
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(overtimeEnterpriseSyncProvider);
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(overtimeEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (!canViewOvertime) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return OvertimeMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return OvertimeTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onNewOvertime: () => NewOvertimeRequestDialog.show(context),
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return OvertimeDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onNewOvertime: () => NewOvertimeRequestDialog.show(context),
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
