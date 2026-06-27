import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/pagination_controls.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/scrollable_wrapper.dart';
import '../../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../providers/attendance_summary/attendance_summary_provider.dart';
import 'attendance_summary_table_header.dart';
import 'attendance_summary_table_row.dart';

class ComponentAttendanceSummaryTable extends ConsumerStatefulWidget {
  const ComponentAttendanceSummaryTable({super.key});

  @override
  ConsumerState<ComponentAttendanceSummaryTable> createState() => _ComponentAttendanceSummaryTableState();
}

class _ComponentAttendanceSummaryTableState extends ConsumerState<ComponentAttendanceSummaryTable> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceSummaryProvider);
    final isDark = context.isDark;

    if (!state.hasSearched) {
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
                'Select Enterprise to View Records',
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
                  'Select an enterprise and apply filters to view attendance summary records.',
                  style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textMuted : AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!state.isLoading && state.error == null && state.records.isEmpty) {
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
                  'No records match your current criteria. Try adjusting the date or org filters.',
                  style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textMuted : AppColors.textTertiary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScrollableSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AttendanceSummaryTableHeader(isDark: isDark),
                  ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 500.h),
                    child: Column(
                      children: [
                        if (state.isLoading)
                          Skeletonizer(
                            enabled: true,
                            child: Column(children: List.generate(10, (index) => _buildTableDataRow(context))),
                          )
                        else if (state.error != null)
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            height: 250.h,
                            width: constraints.maxWidth,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.error_outline, color: AppColors.brandRed, size: 40.r),
                                Gap(16.h),
                                Text(
                                  'Error loading records',
                                  style: context.textTheme.titleMedium?.copyWith(color: AppColors.brandRed),
                                ),
                                Gap(8.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                                  child: Text(
                                    state.error!,
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                                  ),
                                ),
                                Gap(16.h),
                                AppButton.outline(
                                  label: 'Retry',
                                  onPressed: () => ref.read(attendanceSummaryProvider.notifier).refresh(),
                                ),
                              ],
                            ),
                          )
                        else
                          ...List.generate(state.records.length, (index) {
                            final record = state.records[index];

                            return AttendanceSummaryTableRow(record: record, isDark: isDark);
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (state.error == null && (state.totalItems > 0 || state.records.isNotEmpty))
              PaginationControls(
                currentPage: state.currentPage,
                totalPages: state.totalPages == 0 ? 1 : state.totalPages,
                totalItems: state.totalItems,
                pageSize: state.pageSize,
                hasNext: state.hasNext,
                hasPrevious: state.hasPrevious,
                onPrevious: state.hasPrevious
                    ? () => ref.read(attendanceSummaryProvider.notifier).setPage(state.currentPage - 1)
                    : null,
                onNext: state.hasNext
                    ? () => ref.read(attendanceSummaryProvider.notifier).setPage(state.currentPage + 1)
                    : null,
                isLoading: false,
                style: PaginationStyle.simple,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableDataRow(BuildContext context, {AttendanceSummaryRecord? record}) {
    final r = record ?? AttendanceSummaryRecord(employeeName: '—', attendanceStatus: '—');
    return AttendanceSummaryTableRow(record: r, isDark: context.isDark);
  }
}
