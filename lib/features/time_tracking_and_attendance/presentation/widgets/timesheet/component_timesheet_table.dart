import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'timesheet_table_header.dart';
import 'timesheet_table_row.dart';

class TimesheetTable extends ConsumerWidget {
  final AppLocalizations localizations;
  final List<Timesheet> records;
  final bool isDark;
  final bool isLoading;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final int pageSize;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool? paginationIsLoading;

  static final Timesheet _skeletonTimesheet = Timesheet(
    id: 0,
    guid: '',
    employeeId: 0,
    employeeName: 'Loading Name',
    employeeNumber: 'EMP-000',
    departmentName: 'Loading Department',
    weekStartDate: DateTime(2000, 1, 1),
    weekEndDate: DateTime(2000, 1, 7),
    regularHours: 0,
    overtimeHours: 0,
    totalHours: 0,
    status: TimesheetStatus.submitted,
  );

  const TimesheetTable({
    super.key,
    required this.localizations,
    required this.records,
    required this.isDark,
    this.isLoading = false,
    this.paginationInfo,
    this.currentPage = 1,
    this.pageSize = 10,
    this.onPrevious,
    this.onNext,
    this.paginationIsLoading,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: 500.h),
            child: ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TimesheetTableHeader(isDark: isDark),
                  if (isLoading && records.isEmpty)
                    ...List.generate(
                      5,
                      (_) => Skeletonizer(
                        enabled: true,
                        child: TimesheetTableRow(timesheet: _skeletonTimesheet, isDark: isDark),
                      ),
                    )
                  else if (records.isEmpty)
                    SizedBox(
                      width: 900.w,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 48.h),
                        child: Center(
                          child: Text(
                            localizations.noResultsFound,
                            style: TextStyle(fontSize: 16.sp, color: AppColors.textMuted),
                          ),
                        ),
                      ),
                    )
                  else
                    ...records.map(
                      (timesheet) => Skeletonizer(
                        enabled: isLoading,
                        child: TimesheetTableRow(timesheet: timesheet, isDark: isDark),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (paginationInfo != null) ...[
            PaginationControls.fromPaginationInfo(
              paginationInfo: paginationInfo!,
              currentPage: currentPage,
              pageSize: pageSize,
              onPrevious: onPrevious,
              onNext: onNext,
              isLoading: false,
              style: PaginationStyle.simple,
            ),
          ],
        ],
      ),
    );
  }
}
