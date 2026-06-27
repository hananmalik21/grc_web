import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_desktop_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_mobile_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimesheetScreen extends ConsumerStatefulWidget {
  const TimesheetScreen({super.key});

  @override
  ConsumerState<TimesheetScreen> createState() => _TimesheetScreenState();
}

class _TimesheetScreenState extends ConsumerState<TimesheetScreen> with TimesheetPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final enterpriseId = ref.read(timesheetEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(timesheetNotifierProvider.notifier).setCompanyId(enterpriseId.toString());
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(timesheetSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(timesheetEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.timesheets(localizations));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(timesheetEnterpriseSyncProvider);
    final localizations = AppLocalizations.of(context)!;
    final effectiveEnterpriseId = ref.watch(timesheetEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (!canViewTimesheet) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return TimesheetMobileLayout(
        selectedEnterpriseId: effectiveEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onNewTimesheet: () => NewTimesheetDialog.show(context),
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return TimesheetTabletLayout(
        selectedEnterpriseId: effectiveEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onNewTimesheet: () => NewTimesheetDialog.show(context),
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return TimesheetDesktopLayout(
      selectedEnterpriseId: effectiveEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onNewTimesheet: () => NewTimesheetDialog.show(context),
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
