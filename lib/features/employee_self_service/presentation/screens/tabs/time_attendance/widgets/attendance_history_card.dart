import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AttendanceHistoryCard extends StatelessWidget {
  const AttendanceHistoryCard({
    super.key,
    required this.records,
    required this.onViewDetailedReport,
    required this.onViewRecord,
  });

  final List<AttendanceHistoryRecord> records;
  final VoidCallback onViewDetailedReport;
  final ValueChanged<String> onViewRecord;

  @override
  Widget build(BuildContext context) {
    return EssSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.leaveManagement.history.path,
                        width: 20.w,
                        height: 20.w,
                        color: AppColors.primary,
                      ),
                      Gap(8.w),
                      Text('Attendance History', style: context.textTheme.headlineMedium?.copyWith(fontSize: 18.sp)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onViewDetailedReport,
                  child: Text(
                    'View Detailed Report',
                    style: context.textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: AppColors.sidebarSearchBg.withValues(alpha: 0.5),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
            child: Row(
              children: const [
                _HeaderCell(label: 'Date', flex: 2, alignment: TextAlign.left),
                _HeaderCell(label: 'Check In', flex: 2),
                _HeaderCell(label: 'Check Out', flex: 2),
                _HeaderCell(label: 'Hours', flex: 1),
                _HeaderCell(label: 'Status', flex: 2),
                _HeaderCell(label: 'Source', flex: 2),
                _HeaderCell(label: 'Action', flex: 2, alignment: TextAlign.right),
              ],
            ),
          ),
          if (records.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 48.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.schedule_rounded, size: 40.sp, color: AppColors.borderGrey),
                    Gap(14.h),
                    Text(
                      'No attendance records for this month',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
              child: Column(
                children: [
                  for (var index = 0; index < records.length; index++) ...[
                    _AttendanceHistoryRow(record: records[index], onView: () => onViewRecord(records[index].id)),
                    if (index != records.length - 1) Gap(12.h),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.flex, this.alignment = TextAlign.center});

  final String label;
  final int flex;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: alignment,
        style: context.textTheme.labelMedium?.copyWith(
          color: context.isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _AttendanceHistoryRow extends StatelessWidget {
  const _AttendanceHistoryRow({required this.record, required this.onView});

  final AttendanceHistoryRecord record;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(DateFormat('dd MMM yyyy').format(record.date), style: context.textTheme.bodyMedium),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(record.checkIn, style: context.textTheme.bodyMedium)),
          ),
          Expanded(
            flex: 2,
            child: Center(child: Text(record.checkOut, style: context.textTheme.bodyMedium)),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text(record.hours, style: context.textTheme.bodyMedium)),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: DigifySquareCapsule(
                label: record.status.label.capitalizeEachWord,
                backgroundColor: record.status.backgroundColor,
                borderColor: record.status.borderColor,
                textColor: record.status.textColor,
                borderRadius: BorderRadius.circular(7.r),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                record.source,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: AppButton.outline(
                label: 'View',
                svgPath: Assets.icons.viewIconBlue.path,
                width: 84.w,
                height: 34.h,
                onPressed: onView,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
