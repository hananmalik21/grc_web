import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AssignedShiftCard extends StatelessWidget {
  const AssignedShiftCard({super.key, required this.shiftInfo});

  final TimeAttendanceShiftInfo shiftInfo;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      padding: EdgeInsets.all(21.w),
      title: 'Assigned Shift',
      titleIconPath: Assets.icons.sidebar.publicHolidays.path,
      titleIconColor: AppColors.primary,
      child: Column(
        children: [
          _ShiftRow(label: 'Shift Name', value: shiftInfo.shiftName),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),
          _ShiftRow(label: 'Working Hours', value: shiftInfo.workingHours),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),
          _ShiftRow(label: 'Break Time', value: shiftInfo.breakTime),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),
          _ShiftRow(
            label: 'Grace Period',
            value: shiftInfo.gracePeriod,
            valueColor: isDark ? AppColors.infoBorder : AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _ShiftRow extends StatelessWidget {
  const _ShiftRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              fontSize: 12.sp,
              color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
            ),
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 12.sp,
              color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
