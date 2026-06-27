import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/mark_attendance_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/attendance_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/attendance_status_chip.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AttendanceListMobile extends ConsumerWidget {
  const AttendanceListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(attendanceNotifierProvider);
    final notifier = ref.read(attendanceNotifierProvider.notifier);
    final records = state.records;
    final isLoading = state.isLoading;
    final hasSearched = state.hasSearched;

    if (!hasSearched) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
        icon: Icon(
          Icons.search_rounded,
          size: 32.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        title: 'Search to View Attendance',
        subtitle: 'Enter an employee number or apply date filters to view attendance records.',
      );
    }

    if (!isLoading && records.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
        icon: Icon(
          Icons.inbox_outlined,
          size: 32.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        title: 'No Attendance Records Found',
        subtitle: 'No records match your search criteria. Try adjusting your filters.',
      );
    }

    final skeletonRecords = isLoading && records.isEmpty ? List.generate(8, (_) => _skeletonRecord()) : records;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeletonizer(
            enabled: isLoading,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              itemCount: skeletonRecords.length,
              separatorBuilder: (_, _) => Gap(10.h),
              itemBuilder: (context, index) => _AttendanceCard(record: skeletonRecords[index], isDark: isDark),
            ),
          ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: state.currentPage,
            totalPages: state.totalItems == 0 ? 1 : (state.totalItems / state.pageSize).ceil(),
            hasPrevious: state.currentPage > 1,
            hasNext: (state.currentPage * state.pageSize) < state.totalItems,
            onPrevious: state.currentPage > 1 && !isLoading ? () => notifier.setPage(state.currentPage - 1) : null,
            onNext: (state.currentPage * state.pageSize) < state.totalItems && !isLoading
                ? () => notifier.setPage(state.currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  AttendanceRecord _skeletonRecord() => AttendanceRecord(
    employeeName: 'Employee Name',
    employeeId: 'EMP-0000',
    departmentName: 'Department',
    date: DateTime.now(),
    checkIn: '09:00 AM',
    checkOut: '05:00 PM',
    status: 'Present',
    avatarInitials: 'EN',
  );
}

class _AttendanceCard extends StatelessWidget with AttendancePermissionMixin {
  const _AttendanceCard({required this.record, required this.isDark});

  final AttendanceRecord record;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(image: null, fallbackInitial: record.employeeName, size: 36.w),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.employeeName.toUpperCase(),
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    Text(
                      record.employeeId,
                      style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              AttendanceStatusChip(status: record.status),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 10.h,
            children: [
              _InfoCell(
                label: 'Department',
                value: record.departmentName.isEmpty ? '--' : record.departmentName,
                labelColor: labelColor,
                isDark: isDark,
              ),
              _InfoCell(
                label: 'Date',
                value: DateFormat('MMM d, yyyy').format(record.date),
                labelColor: labelColor,
                isDark: isDark,
              ),
              _InfoCell(
                label: 'Check In',
                value: record.displayValue(record.checkIn),
                labelColor: labelColor,
                isDark: isDark,
              ),
              _InfoCell(
                label: 'Check Out',
                value: record.displayValue(record.checkOut),
                labelColor: labelColor,
                isDark: isDark,
              ),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (record.attendance != null && canUpdateAttendance)
                DigifyAssetButton(
                  assetPath: Assets.icons.editIconGreen.path,
                  onTap: () => MarkAttendanceDialog.show(context, attendanceRecord: record),
                  width: 20.w,
                  height: 20.h,
                  color: AppColors.editIconGreen,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({required this.label, required this.value, required this.labelColor, required this.isDark});

  final String label;
  final String value;
  final Color labelColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.38.sw,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: labelColor),
          ),
          Gap(2.h),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
