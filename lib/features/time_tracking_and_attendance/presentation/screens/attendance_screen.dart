import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_desktop_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_mobile_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_tablet_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/mark_attendance_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_permission_mixin.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> with AttendancePermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final enterpriseId = ref.read(attendanceEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(attendanceNotifierProvider.notifier).setCompanyId(enterpriseId.toString());
      }
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(attendanceSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(attendanceEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.attendanceLogs(localizations));
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(attendanceEnterpriseSyncProvider);
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(attendanceEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (!canViewAttendance) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return AttendanceMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onMarkAttendance: () => MarkAttendanceDialog.show(context),
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return AttendanceTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onMarkAttendance: () => MarkAttendanceDialog.show(context),
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return AttendanceDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onMarkAttendance: () => MarkAttendanceDialog.show(context),
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
