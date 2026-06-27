import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/work_schedule_selection_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeWorkScheduleSelectionField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final int enterpriseId;
  final WorkSchedule? selectedWorkSchedule;
  final ValueChanged<WorkSchedule?> onChanged;

  const EmployeeWorkScheduleSelectionField({
    super.key,
    required this.label,
    this.isRequired = true,
    required this.enterpriseId,
    this.selectedWorkSchedule,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? context.themeTextPrimary : AppColors.inputLabel,
                  fontFamily: 'Inter',
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.deleteIconRed,
                    fontFamily: 'Inter',
                  ),
                ),
            ],
          ),
        ),
        Gap(6.h),
        InkWell(
          onTap: () async {
            final selected = await EmployeeWorkScheduleSelectionDialog.show(
              context: context,
              enterpriseId: enterpriseId,
              selectedScheduleId: selectedWorkSchedule?.workScheduleId,
            );

            if (selected != null) {
              onChanged(selected);
            }
          },
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedWorkSchedule?.scheduleNameEn ?? 'Select Work Schedule',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: selectedWorkSchedule != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DigifyAsset(
                  assetPath: Assets.icons.workforce.chevronRight.path,
                  color: AppColors.textSecondary,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
