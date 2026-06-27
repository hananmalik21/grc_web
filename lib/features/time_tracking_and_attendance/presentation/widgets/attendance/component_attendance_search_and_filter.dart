import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/attendance_desktop_search_and_filter.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/attendance_mobile_search_and_filter.dart';
import 'package:flutter/material.dart';

/// Routes to [AttendanceMobileSearchAndFilter] or [AttendanceDesktopSearchAndFilter]
/// based on screen width.
class AttendanceSearchAndFilter extends StatelessWidget {
  const AttendanceSearchAndFilter({
    super.key,
    required this.employeeNumberController,
    required this.fromDate,
    required this.toDate,
    required this.onSearchChanged,
    required this.onFromDateSelected,
    required this.onToDateSelected,
    required this.onApply,
    required this.onClear,
    required this.isDark,
    this.onImport,
    this.onExport,
    this.isExporting = false,
  });

  final TextEditingController employeeNumberController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<DateTime> onFromDateSelected;
  final ValueChanged<DateTime> onToDateSelected;
  final VoidCallback onApply;
  final VoidCallback onClear;
  final bool isDark;
  final VoidCallback? onImport;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    if (context.isMobileLayout) {
      return AttendanceMobileSearchAndFilter(
        employeeNumberController: employeeNumberController,
        fromDate: fromDate,
        toDate: toDate,
        onSearchChanged: onSearchChanged,
        onFromDateSelected: onFromDateSelected,
        onToDateSelected: onToDateSelected,
        onApply: onApply,
        onClear: onClear,
        isDark: isDark,
        onImport: onImport,
        onExport: onExport,
        isExporting: isExporting,
      );
    }
    return AttendanceDesktopSearchAndFilter(
      employeeNumberController: employeeNumberController,
      fromDate: fromDate,
      toDate: toDate,
      onSearchChanged: onSearchChanged,
      onFromDateSelected: onFromDateSelected,
      onToDateSelected: onToDateSelected,
      onApply: onApply,
      onClear: onClear,
      isDark: isDark,
    );
  }
}
