import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'attendance_expanded_panel.dart';
import 'attendance_table_header.dart';
import 'attendance_table_row.dart';
import 'attendance_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceTable extends ConsumerWidget {
  final List<AttendanceRecord> records;
  final bool isDark;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final bool isLoading;
  final bool hasSearched;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const AttendanceTable({
    super.key,
    required this.records,
    required this.isDark,
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    this.isLoading = false,
    this.hasSearched = false,
    this.onPrevious,
    this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedIndex = ref.watch(attendanceExpandedIndexProvider);

    // Show empty state without table when no search has been performed
    if (!hasSearched) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_rounded,
                  size: 64.sp,
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                ),
              ),
              Gap(24.h),
              Text(
                'Search to View Attendance',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                child: Text(
                  'Enter an employee number or apply date filters to view attendance records',
                  style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textMuted : AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show empty state when search returned no results
    if (!isLoading && records.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 80.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inbox_outlined,
                  size: 64.sp,
                  color: isDark ? AppColors.textMuted : AppColors.textSecondary,
                ),
              ),
              Gap(24.h),
              Text(
                'No Attendance Records Found',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 48.w),
                child: Text(
                  'No attendance records match your current search criteria. Try adjusting your filters or search term.',
                  style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textMuted : AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show table with data or loading state
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
                  AttendanceTableHeader(isDark: isDark),
                  if (isLoading)
                    AttendanceTableSkeleton(isDark: isDark)
                  else
                    ...List.generate(records.length, (index) {
                      final record = records[index];
                      final isExpanded = expandedIndex == index;
                      final isLast = index == records.length - 1;

                      return Column(
                        children: [
                          AttendanceTableRow(
                            record: record,
                            isDark: isDark,
                            isExpanded: isExpanded,
                            onToggle: () {
                              final notifier = ref.read(attendanceExpandedIndexProvider.notifier);
                              if (expandedIndex == index) {
                                notifier.state = null;
                              } else {
                                notifier.state = index;
                              }
                            },
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isExpanded) AttendanceExpandedPanel(record: record, isDark: isDark),
                                if (isExpanded && !isLast)
                                  Divider(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ),
          PaginationControls(
            currentPage: currentPage,
            totalPages: totalItems == 0 ? 1 : (totalItems / pageSize).ceil(),
            totalItems: totalItems,
            pageSize: pageSize,
            hasNext: (currentPage * pageSize) < totalItems,
            hasPrevious: currentPage > 1,
            onPrevious: onPrevious,
            onNext: onNext,
            isLoading: false,
            style: PaginationStyle.simple,
          ),
        ],
      ),
    );
  }
}
