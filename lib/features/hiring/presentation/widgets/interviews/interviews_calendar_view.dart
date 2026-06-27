import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/models/interview_status_code.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_table_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/interview_status_capsule.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/quick_info_dialog.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mixins/interviews_calendar_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class InterviewsCalendarView extends ConsumerStatefulWidget {
  const InterviewsCalendarView({super.key});

  @override
  ConsumerState<InterviewsCalendarView> createState() => _InterviewsCalendarViewState();
}

class _InterviewsCalendarViewState extends ConsumerState<InterviewsCalendarView>
    with InterviewsCalendarMixin<InterviewsCalendarView> {
  @override
  void initState() {
    super.initState();
    initCalendarState();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;

    final allInterviews = ref.watch(interviewsListProvider).valueOrNull ?? const [];
    final filteredInterviews = allInterviews.where((interview) => interview.dateTime != null).toList();

    final calendarDays = generateCalendarDays();

    return Container(
      padding: EdgeInsets.all(isMobile ? 12.r : 24.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, isMobile),
          Gap(20.h),
          _buildWeekdaysHeader(context),
          Gap(8.h),
          _buildDaysGrid(context, calendarDays, filteredInterviews, isMobile),
          Gap(16.h),
          const DigifyDivider.horizontal(),
          Gap(12.h),
          _buildColorLegend(context),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, bool isMobile) {
    final isDark = context.isDark;
    final formattedMonth = DateFormat('MMMM yyyy').format(focusedMonth);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formattedMonth,
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: isMobile ? 16.sp : 20.sp,
            fontWeight: FontWeight.w600,
            color: context.themeTextPrimary,
          ),
        ),
        Row(
          children: [
            InkWell(
              onTap: onTodayPressed,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  'Today',
                  style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: context.themeTextPrimary),
                ),
              ),
            ),
            Gap(8.w),
            InkWell(
              onTap: onPrevMonthPressed,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.chevron_left, size: 20.w, color: context.themeTextPrimary),
              ),
            ),
            Gap(8.w),
            InkWell(
              onTap: onNextMonthPressed,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  border: Border.all(color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.chevron_right, size: 20.w, color: context.themeTextPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekdaysHeader(BuildContext context) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                day,
                style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: context.themeTextSecondary),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(BuildContext context, List<DateTime> days, List<Interview> interviews, bool isMobile) {
    final isDark = context.isDark;
    final double cellHeight = isMobile ? 55.h : 130.h;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        mainAxisExtent: cellHeight,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        final isSelected = DateUtils.isSameDay(day, selectedDay);
        final isCurrentMonth = day.month == focusedMonth.month;
        final isToday = DateUtils.isSameDay(day, DateTime.now());

        final dayInterviews = interviews.where((i) => DateUtils.isSameDay(i.dateTime, day)).toList();

        Color? cellBackground;
        Color? cellBorderColor;
        Color dayNumberColor = isCurrentMonth ? context.themeTextPrimary : context.themeTextMuted;

        if (isSelected) {
          cellBackground = isDark ? AppColors.infoBgDark.withValues(alpha: 0.3) : AppColors.infoBg;
          cellBorderColor = AppColors.primary;
          dayNumberColor = AppColors.primary;
        } else {
          cellBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
        }

        return InkWell(
          onTap: () {
            onSelectDay(day);
            QuickInfoDialog.show(context, date: day, dayInterviews: dayInterviews);
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: cellBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: cellBorderColor, width: isSelected ? 1.5 : 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isToday ? 4.r : 0),
                      decoration: isToday
                          ? const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)
                          : null,
                      child: Text(
                        '${day.day}',
                        style: context.bodyMedium.copyWith(
                          fontWeight: isToday || isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14.sp,
                          color: isToday ? AppColors.onPrimary : dayNumberColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isMobile) ...[
                  Gap(4.h),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dayInterviews.length > 2 ? 3 : dayInterviews.length,
                      separatorBuilder: (context, index) => Gap(3.h),
                      itemBuilder: (context, index) {
                        if (index == 2 && dayInterviews.length > 2) {
                          return Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                            child: Text(
                              '+${dayInterviews.length - 2} more',
                              style: context.bodySmall.copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: context.themeTextSecondary,
                              ),
                            ),
                          );
                        }

                        final interview = dayInterviews[index];
                        return _buildEventCapsule(context, interview);
                      },
                    ),
                  ),
                ] else ...[
                  const Spacer(),
                  if (dayInterviews.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: dayInterviews.take(4).map((i) {
                        final dotColor = _statusDotColor(context, i);
                        return Container(
                          width: 5.r,
                          height: 5.r,
                          margin: EdgeInsets.symmetric(horizontal: 1.w),
                          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
                        );
                      }).toList(),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Color _statusDotColor(BuildContext context, Interview interview) {
    final style = InterviewStatusCapsuleStyle.fromStatusCode(interview.statusCode, isDark: context.isDark);
    return style.textColor;
  }

  Widget _buildEventCapsule(BuildContext context, Interview interview) {
    final style = InterviewStatusCapsuleStyle.fromStatusCode(interview.statusCode, isDark: context.isDark);

    final formattedTime = interview.dateTime != null ? DateFormat('h:mm').format(interview.dateTime!) : '';
    final shortName = interview.candidateName.split(' ').first;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(color: style.backgroundColor, borderRadius: BorderRadius.circular(4.r)),
      child: Text(
        '$formattedTime $shortName',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: context.bodySmall.copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600, color: style.textColor),
      ),
    );
  }

  Widget _buildColorLegend(BuildContext context) {
    final isDark = context.isDark;
    final scheduledStyle = InterviewStatusCapsuleStyle.fromStatusCode(InterviewStatusCode.scheduled, isDark: isDark);
    final rescheduledStyle = InterviewStatusCapsuleStyle.fromStatusCode(
      InterviewStatusCode.rescheduled,
      isDark: isDark,
    );
    final completedStyle = InterviewStatusCapsuleStyle.fromStatusCode(InterviewStatusCode.completed, isDark: isDark);
    final cancelledStyle = InterviewStatusCapsuleStyle.fromStatusCode(InterviewStatusCode.cancelled, isDark: isDark);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Wrap(
        spacing: 16.w,
        runSpacing: 8.h,
        children: [
          _buildLegendItem(
            context,
            color: scheduledStyle.backgroundColor,
            borderColor: scheduledStyle.borderColor,
            label: 'Scheduled',
          ),
          _buildLegendItem(
            context,
            color: rescheduledStyle.backgroundColor,
            borderColor: rescheduledStyle.borderColor,
            label: 'Rescheduled',
          ),
          _buildLegendItem(
            context,
            color: completedStyle.backgroundColor,
            borderColor: completedStyle.borderColor,
            label: 'Completed',
          ),
          _buildLegendItem(
            context,
            color: cancelledStyle.backgroundColor,
            borderColor: cancelledStyle.borderColor,
            label: 'Cancelled',
          ),
          _buildLegendItem(
            context,
            color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.3) : AppColors.infoBg,
            borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
            label: 'Today',
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context, {
    required Color color,
    required Color borderColor,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.r,
          height: 16.r,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Gap(8.w),
        Text(
          label,
          style: context.bodyMedium.copyWith(fontWeight: FontWeight.normal, color: context.themeTextSecondary),
        ),
      ],
    );
  }
}
