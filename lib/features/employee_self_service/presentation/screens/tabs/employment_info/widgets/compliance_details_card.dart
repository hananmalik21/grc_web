import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employment_info/employment_info_state.dart';
import 'package:grc/features/employee_self_service/presentation/screens/tabs/employment_info/widgets/employment_info_field.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComplianceDetailsCard extends StatelessWidget {
  final EmploymentInfoState state;

  const ComplianceDetailsCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      title: 'Compliance Details',
      titleIconPath: Assets.icons.employeeSelfService.compliance.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employment Sector',
            style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: AppColors.sidebarCategoryText),
          ),
          Gap(8.h),
          DigifySquareCapsule(
            label: state.employmentSector,
            backgroundColor: context.themeInfoBg,
            textColor: AppColors.roleActionBlue,
            borderColor: context.themeInfoBorder,
            borderRadius: BorderRadius.circular(10.r),
          ),
          Gap(20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmploymentInfoField(label: 'Contract Type', value: state.contractType),
              ),
              Gap(20.w),
              Expanded(
                child: EmploymentInfoField(label: 'Contract End Date', value: state.contractEndDate),
              ),
            ],
          ),
          Gap(20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(13.5.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : AppColors.infoBg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
            ),
            child: Column(
              children: [
                _InlineInfoRow(label: 'Overtime Eligibility', value: state.overtimeEligibility),
                Gap(10.h),
                _InlineInfoRow(label: 'Work Location', value: state.workLocation),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InlineInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: AppColors.primary),
          ),
        ),
        Gap(16.w),
        Text(
          value,
          style: context.textTheme.headlineMedium?.copyWith(fontSize: 12.sp, color: context.themeTextPrimary),
        ),
      ],
    );
  }
}
