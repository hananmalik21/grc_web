import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/attendance_list_mobile.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_search_and_filter.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceContent extends ConsumerStatefulWidget {
  const AttendanceContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    this.onImport,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;
  final VoidCallback? onImport;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  ConsumerState<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends ConsumerState<AttendanceContent> {
  final TextEditingController _employeeNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _employeeNumberController.text = ref.read(attendanceNotifierProvider).employeeNumber;
  }

  @override
  void dispose() {
    _employeeNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final state = ref.watch(attendanceNotifierProvider);
    final notifier = ref.read(attendanceNotifierProvider.notifier);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            widget.header,
            widget.enterpriseSelector,
            AttendanceSearchAndFilter(
              employeeNumberController: _employeeNumberController,
              fromDate: state.fromDate,
              toDate: state.toDate,
              onSearchChanged: notifier.setEmployeeNumber,
              onFromDateSelected: notifier.setFromDate,
              onToDateSelected: notifier.setToDate,
              onApply: notifier.applyDateFilters,
              onClear: notifier.clearDateFilters,
              isDark: isDark,
              onImport: widget.onImport,
              onExport: widget.onExport,
              isExporting: widget.isExporting,
            ),
            if (isMobile)
              const AttendanceListMobile()
            else
              AttendanceTable(
                records: state.records,
                isDark: isDark,
                currentPage: state.currentPage,
                pageSize: state.pageSize,
                totalItems: state.totalItems,
                isLoading: state.isLoading,
                hasSearched: state.hasSearched,
                onPrevious: state.currentPage > 1 ? () => notifier.setPage(state.currentPage - 1) : null,
                onNext: (state.currentPage * state.pageSize) < state.totalItems
                    ? () => notifier.setPage(state.currentPage + 1)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
