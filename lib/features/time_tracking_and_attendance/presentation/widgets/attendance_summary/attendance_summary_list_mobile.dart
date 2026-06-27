import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/app_shadows.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/app_avatar.dart';
import '../../../../../core/widgets/common/digify_divider.dart';
import '../../../../../core/widgets/common/digify_status_capsule.dart';
import '../../../../../core/widgets/common/pagination_controls.dart';
import '../../../../../core/widgets/mobile/mobile_state_card.dart';
import '../../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../providers/attendance_summary/attendance_summary_provider.dart';
import '../../screens/mixins/attendance_summary_formatters.dart';

class AttendanceSummaryListMobile extends ConsumerWidget {
  const AttendanceSummaryListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(attendanceSummaryProvider);
    final notifier = ref.read(attendanceSummaryProvider.notifier);

    if (!state.hasSearched) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
        icon: Icon(Icons.search_rounded, size: 32.sp, color: isDark ? AppColors.textMuted : AppColors.textSecondary),
        title: 'Select Enterprise',
        subtitle: 'Select an enterprise and apply filters to view attendance records.',
      );
    }

    if (state.isLoading) {
      return _AttendanceSummarySkeletonList(isDark: isDark);
    }

    if (state.error != null) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: AppColors.errorBg,
        icon: Icon(Icons.error_outline, size: 32.sp, color: AppColors.brandRed),
        title: 'Error Loading Records',
        subtitle: state.error!,
        action: TextButton(
          onPressed: notifier.refresh,
          child: Text(
            'Retry',
            style: TextStyle(color: AppColors.brandRed, fontSize: 13.sp),
          ),
        ),
      );
    }

    if (state.records.isEmpty) {
      return MobileStateCard(
        isDark: isDark,
        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
        icon: Icon(Icons.inbox_outlined, size: 32.sp, color: isDark ? AppColors.textMuted : AppColors.textSecondary),
        title: 'No Records Found',
        subtitle: 'No records match your filters. Try adjusting the date or org filters.',
      );
    }

    final bg = isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(12.r),
            itemCount: state.records.length,
            separatorBuilder: (_, _) => Gap(8.h),
            itemBuilder: (context, index) => _AttendanceSummaryCardItem(record: state.records[index], isDark: isDark),
          ),
          const DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            child: MobilePaginationControls(
              isDark: isDark,
              currentPage: state.currentPage,
              totalPages: state.totalPages == 0 ? 1 : state.totalPages,
              hasPrevious: state.hasPrevious,
              hasNext: state.hasNext,
              onPrevious: state.hasPrevious ? () => notifier.setPage(state.currentPage - 1) : null,
              onNext: state.hasNext ? () => notifier.setPage(state.currentPage + 1) : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceSummaryCardItem extends StatelessWidget {
  const _AttendanceSummaryCardItem({required this.record, required this.isDark});

  final AttendanceSummaryRecord record;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackground;
    final cardBorder = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cardBorder),
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
                      record.employeeName ?? '—',
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, fontSize: 13.sp),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      AttendanceSummaryFormatters.formatDate(record.attendanceDate),
                      style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: record.attendanceStatus ?? '—'),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _TimeBox(
                  label: 'Check In',
                  time: AttendanceSummaryFormatters.formatTime(record.checkInTime),
                  isDark: isDark,
                  bg: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                  textColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: _TimeBox(
                  label: 'Check Out',
                  time: AttendanceSummaryFormatters.formatTime(record.checkOutTime),
                  isDark: isDark,
                  bg: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.5) : AppColors.greenBg,
                  textColor: isDark ? AppColors.textSecondaryDark : AppColors.greenText,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Row(
            children: [
              Expanded(
                child: _MetricField(label: 'Hours Worked', value: record.hoursWorked ?? '--', isDark: isDark),
              ),
              Gap(8.w),
              Expanded(
                child: _MetricField(
                  label: 'Overtime',
                  value: record.overtimeHours != null ? '${record.overtimeHours}h' : '--',
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({
    required this.label,
    required this.time,
    required this.isDark,
    required this.bg,
    required this.textColor,
  });

  final String label;
  final String time;
  final bool isDark;
  final Color bg;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10.sp, color: textColor.withValues(alpha: 0.7), fontWeight: FontWeight.w500),
          ),
          Gap(2.h),
          Text(
            time,
            style: TextStyle(fontSize: 12.sp, color: textColor, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MetricField extends StatelessWidget {
  const _MetricField({required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
        ),
        Gap(2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _AttendanceSummarySkeletonList extends StatelessWidget {
  const _AttendanceSummarySkeletonList({required this.isDark});

  final bool isDark;

  static final _placeholder = AttendanceSummaryRecord(
    employeeName: 'John Placeholder',
    attendanceStatus: 'Present',
    attendanceDate: '2026-01-01T00:00:00',
    checkInTime: '2026-01-01T09:00:00',
    checkOutTime: '2026-01-01T17:00:00',
    hoursWorked: '08:00',
    overtimeHours: 0,
  );

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;

    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(12.r),
          itemCount: 5,
          separatorBuilder: (_, _) => Gap(8.h),
          itemBuilder: (_, _) => _AttendanceSummaryCardItem(record: _placeholder, isDark: isDark),
        ),
      ),
    );
  }
}
