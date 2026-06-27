import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_stat_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttendanceStatsGrid extends StatelessWidget {
  final int totalStaff;
  final int present;
  final int lateCount;
  final int absent;
  final int halfDay;
  final int onLeave;
  final bool isDark;

  const AttendanceStatsGrid({
    super.key,
    required this.totalStaff,
    required this.present,
    required this.lateCount,
    required this.absent,
    required this.halfDay,
    required this.onLeave,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final cards = [
      AttendanceStatCard(
        label: 'Total Staff',
        value: totalStaff.toString(),
        iconPath: Assets.icons.attendance.staff.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Present',
        value: present.toString(),
        iconPath: Assets.icons.attendance.present.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Late',
        value: lateCount.toString(),
        iconPath: Assets.icons.attendance.late.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Absent',
        value: absent.toString(),
        iconPath: Assets.icons.attendance.absent.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'Half Day',
        value: halfDay.toString(),
        iconPath: Assets.icons.attendance.halfDay.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
      AttendanceStatCard(
        label: 'On Leave',
        value: onLeave.toString(),
        iconPath: Assets.icons.attendance.leave.path,
        iconBackgroundColor: AppColors.jobRoleBg,
        iconColor: AppColors.primary,
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        children: cards.map((card) => SizedBox(width: (context.deviceWidth - 64.w) / 2, child: card)).toList(),
      );
    }

    return Row(
      children: cards
          .map(
            (card) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: card == cards.last ? 0 : 16.w),
                child: card,
              ),
            ),
          )
          .toList(),
    );
  }
}
