import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance_summary/attendance_summary_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin AttendanceSummaryLogicMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void initAttendanceSummary() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(attendanceSummaryProvider.notifier).refresh();
    });
  }

  void onEnterpriseChanged(int? enterpriseId) {
    ref.read(attendanceSummarySelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  void refreshSummary() => ref.read(attendanceSummaryProvider.notifier).refresh();

  void setPage(int page) => ref.read(attendanceSummaryProvider.notifier).setPage(page);

  void setFromDate(DateTime? date) => ref.read(attendanceSummaryProvider.notifier).setFromDate(date);

  void setToDate(DateTime? date) => ref.read(attendanceSummaryProvider.notifier).setToDate(date);

  void applyDateRange() => ref.read(attendanceSummaryProvider.notifier).applyDateRange();

  void clearDateFilters() => ref.read(attendanceSummaryProvider.notifier).clearDateFilters();

  void setOrgFilter(String? orgUnitId, String? levelCode) =>
      ref.read(attendanceSummaryProvider.notifier).setOrgFilter(orgUnitId, levelCode);
}
