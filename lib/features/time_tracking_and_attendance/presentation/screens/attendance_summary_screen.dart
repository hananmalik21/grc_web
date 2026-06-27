import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_summary_desktop_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_summary_mobile_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_summary_tablet_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/attendance_summary_logic_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/attendance_summary_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceSummaryScreen extends ConsumerStatefulWidget {
  const AttendanceSummaryScreen({super.key});

  @override
  ConsumerState<AttendanceSummaryScreen> createState() => _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends ConsumerState<AttendanceSummaryScreen>
    with AttendanceSummaryPermissionMixin, AttendanceSummaryLogicMixin {
  @override
  void initState() {
    super.initState();
    initAttendanceSummary();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final effectiveEnterpriseId = ref.watch(attendanceSummaryEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (!canViewAttendanceSummary) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return AttendanceSummaryMobileLayout(
        selectedEnterpriseId: effectiveEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return AttendanceSummaryTabletLayout(
        selectedEnterpriseId: effectiveEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return AttendanceSummaryDesktopLayout(
      selectedEnterpriseId: effectiveEnterpriseId,
      onEnterpriseChanged: onEnterpriseChanged,
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(attendanceSummaryEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.attendanceSummary(localizations));
  }
}
