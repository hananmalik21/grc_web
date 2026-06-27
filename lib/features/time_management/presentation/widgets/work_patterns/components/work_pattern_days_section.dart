import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternDaysSection extends StatelessWidget {
  final String label;
  final String dayType;
  final WorkPattern workPattern;

  const WorkPatternDaysSection({super.key, required this.label, required this.dayType, required this.workPattern});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(12.h),
        _DaysRow(workPattern: workPattern, dayType: dayType, isDark: isDark),
      ],
    );
  }
}

class _DaysRow extends StatelessWidget {
  final WorkPattern workPattern;
  final String dayType;
  final bool isDark;

  const _DaysRow({required this.workPattern, required this.dayType, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final workingDayNumbers = workPattern.days
        .where((day) => day.dayType == 'WORK')
        .map((day) => day.dayOfWeek)
        .toSet();
    final restDayNumbers = workPattern.days.where((day) => day.dayType == 'REST').map((day) => day.dayOfWeek).toSet();
    final offDayNumbers = workPattern.days.where((day) => day.dayType == 'OFF').map((day) => day.dayOfWeek).toSet();

    return Row(
      children: List.generate(7, (index) {
        final dayNumber = index + 1;
        final isSelected = switch (dayType) {
          'WORK' => workingDayNumbers.contains(dayNumber),
          'REST' => restDayNumbers.contains(dayNumber),
          'OFF' => offDayNumbers.contains(dayNumber),
          _ => false,
        };

        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: index < 6 ? 8.w : 0),
            child: _DayChip(label: dayNames[index], isSelected: isSelected, isDark: isDark, dayType: dayType),
          ),
        );
      }),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final String dayType;

  const _DayChip({required this.label, required this.isSelected, required this.isDark, required this.dayType});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (!isSelected) {
      backgroundColor = AppColors.workPatternDisabledDayBg;
      textColor = AppColors.workPatternDisabledDayText;
    } else {
      switch (dayType) {
        case 'WORK':
          backgroundColor = AppColors.shiftActiveStatusBg;
          textColor = AppColors.shiftActiveStatusText;
        case 'REST':
          backgroundColor = AppColors.workPatternRestDayBg;
          textColor = AppColors.workPatternRestDayText;
        case 'OFF':
          backgroundColor = AppColors.workPatternOffDayBg;
          textColor = AppColors.workPatternOffDayText;
        default:
          backgroundColor = AppColors.workPatternDisabledDayBg;
          textColor = AppColors.workPatternDisabledDayText;
      }
    }

    return Container(
      height: 44.h,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(10.r)),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: context.textTheme.titleSmall?.copyWith(color: textColor),
      ),
    );
  }
}
