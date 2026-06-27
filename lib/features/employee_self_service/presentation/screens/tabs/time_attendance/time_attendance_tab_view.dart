import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_provider.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/time_attendance/widgets/assigned_shift_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/time_attendance/widgets/attendance_history_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/time_attendance/widgets/geofence_status_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/time_attendance/widgets/time_attendance_overview_card.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/time_attendance/widgets/time_attendance_stat_card.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TimeAttendanceTabView extends ConsumerWidget {
  const TimeAttendanceTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timeAttendanceProvider);
    final notifier = ref.read(timeAttendanceProvider.notifier);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTabHeader(title: state.headerTitle, description: state.headerSubtitle),
          Gap(24.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 620;
              if (isStacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DigifySelectField<DateTime>(
                      value: state.selectedMonth,
                      items: state.availableMonths,
                      itemLabelBuilder: (month) => DateFormat('MMMM yyyy').format(month),
                      onChanged: (month) {
                        if (month != null) notifier.setSelectedMonth(month);
                      },
                      fillColor: AppColors.cardBackground,
                    ),
                    Gap(10.h),
                    AppButton.primary(
                      label: 'Export',
                      svgPath: Assets.icons.downloadIcon.path,
                      onPressed: () {
                        ToastService.info(context, 'Attendance export is coming soon.');
                      },
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(width: 180.w),
                    child: DigifySelectField<DateTime>(
                      value: state.selectedMonth,
                      items: state.availableMonths,
                      itemLabelBuilder: (month) => DateFormat('MMMM yyyy').format(month),
                      onChanged: (month) {
                        if (month != null) notifier.setSelectedMonth(month);
                      },
                      fillColor: AppColors.cardBackground,
                    ),
                  ),
                  Gap(10.w),
                  AppButton.primary(
                    label: 'Export',
                    svgPath: Assets.icons.downloadIcon.path,
                    onPressed: () {
                      ToastService.info(context, 'Attendance export is coming soon.');
                    },
                  ),
                ],
              );
            },
          ),
          Gap(18.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 1120;
              final leftColumn = Column(
                children: [
                  TimeAttendanceOverviewCard(
                    currentServerTime: state.currentServerTime,
                    verificationInfo: state.verificationInfo,
                    checkInTime: state.checkInTime,
                    checkOutTime: state.checkOutTime,
                    isClockedIn: state.isClockedIn,
                    verificationCaption: state.verificationCaption,
                    onClockPressed: () {
                      notifier.toggleClockState();
                      ToastService.success(
                        context,
                        state.isClockedIn ? 'Checked out successfully.' : 'Checked in successfully.',
                      );
                    },
                  ),
                  Gap(20.h),
                  GeofenceStatusCard(
                    geofenceInfo: state.geofenceInfo,
                    onOpenMap: () {
                      ToastService.info(context, 'Full map view is not connected yet.');
                    },
                  ),
                  Gap(20.h),
                  AssignedShiftCard(shiftInfo: state.shiftInfo),
                ],
              );

              final rightColumn = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, statConstraints) {
                      final stackedStats = statConstraints.maxWidth < 720;
                      if (stackedStats) {
                        return Column(
                          children: [
                            for (var index = 0; index < state.summaryStats.length; index++) ...[
                              TimeAttendanceStatCard(stat: state.summaryStats[index]),
                              if (index != state.summaryStats.length - 1) Gap(12.h),
                            ],
                          ],
                        );
                      }

                      return Row(
                        children: [
                          for (var index = 0; index < state.summaryStats.length; index++) ...[
                            Expanded(child: TimeAttendanceStatCard(stat: state.summaryStats[index])),
                            if (index != state.summaryStats.length - 1) Gap(12.w),
                          ],
                        ],
                      );
                    },
                  ),
                  Gap(18.h),
                  AttendanceHistoryCard(
                    records: state.filteredRecords,
                    onViewDetailedReport: () {
                      ToastService.info(context, 'Detailed attendance report is coming soon.');
                    },
                    onViewRecord: (recordId) {
                      ToastService.info(context, 'Viewing attendance record $recordId');
                    },
                  ),
                ],
              );

              if (isStacked) {
                return Column(children: [leftColumn, Gap(20.h), rightColumn]);
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 310.w, child: leftColumn),
                  Gap(20.w),
                  Expanded(child: rightColumn),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
