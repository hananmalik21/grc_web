import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/time_management/domain/config/work_pattern_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditableWorkPatternDaysSection extends StatelessWidget {
  final String label;
  final bool isDark;
  final Set<int> selectedDays;
  final ValueChanged<int> onDayToggle;
  final bool isRequired;
  final bool compact;

  const EditableWorkPatternDaysSection({
    super.key,
    required this.label,
    required this.isDark,
    required this.selectedDays,
    required this.onDayToggle,
    required this.isRequired,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.inputLabel,
              height: 20 / 13.8,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.deleteIconRed),
                    ),
                  ]
                : null,
          ),
        ),
        Gap(12.h),
        Row(
          children: List.generate(7, (index) {
            final dayNumber = index + 1;
            final isSelected = selectedDays.contains(dayNumber);

            return Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(end: index < 6 ? 6.w : 0),
                child: InkWell(
                  onTap: () => onDayToggle(dayNumber),
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: compact ? 10.h : 13.h,
                      horizontal: compact ? 2.w : 4.w,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                        width: 1.w,
                      ),
                    ),
                    child: compact
                        ? Center(
                            child: Text(
                              WorkPatternConfig.dayNames[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 13.w,
                                height: 13.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder),
                                    width: 1.5.w,
                                  ),
                                  color: isSelected ? AppColors.primary : Colors.transparent,
                                ),
                              ),
                              Gap(8.w),
                              Text(
                                WorkPatternConfig.dayNames[index],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
