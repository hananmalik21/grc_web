import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employment_info/employment_info_state.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info/widgets/employment_info_field.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CurrentAssignmentCard extends StatelessWidget {
  final EmploymentInfoState state;

  const CurrentAssignmentCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      title: 'Current Assignment',
      titleIconPath: Assets.icons.basicInfoDivisionIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: Assets.icons.employeeManagement.assignment.path,
                  width: 24,
                  height: 24,
                  color: AppColors.primary,
                ),
              ),
              Gap(14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Business Unit / Department',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.sidebarCategoryText,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      state.businessUnit,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontSize: 14.sp,
                        color: context.themeTextPrimary,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      '• ${state.businessUnitSubtitle}',
                      style: context.textTheme.labelSmall?.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.sidebarSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmploymentInfoField(label: 'Position', value: state.position),
              ),
              Gap(20.w),
              Expanded(
                child: EmploymentInfoField(label: 'Original Hire Date', value: state.originalHireDate),
              ),
            ],
          ),
          Gap(20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmploymentInfoField(label: 'Seniority Date', value: state.seniorityDate),
              ),
              Gap(20.w),
              Expanded(
                child: EmploymentInfoField(label: 'Grade', value: state.grade),
              ),
            ],
          ),
          Gap(20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmploymentInfoField(label: 'Step', value: state.step),
              ),
              Gap(20.w),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          Gap(16.h),
          Divider(color: isDark ? AppColors.cardBorderDark : AppColors.sidebarSearchBg, height: 1),
          Gap(14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmploymentInfoField(label: 'Work Schedule', value: state.workSchedule),
              ),
              Gap(20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assignment Status',
                      style: context.textTheme.labelMedium?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.sidebarCategoryText,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Gap(6.h),
                    DigifySquareCapsule(
                      label: state.assignmentStatus.toUpperCase(),
                      backgroundColor: AppColors.approvalRequiredBg,
                      textColor: AppColors.approvalRequiredText,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
