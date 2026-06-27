import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EligibilityCriteriaSkeleton extends StatelessWidget {
  final bool isDark;

  const EligibilityCriteriaSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Eligibility Criteria',
      iconPath: Assets.icons.leaveManagement.shield.path,
      child: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14.h,
          children: [
            _buildSubsectionSkeleton('Years of Service', Assets.icons.clockIcon.path),
            _buildSubsectionSkeleton('Employee Category', Assets.icons.leaveManagement.globe.path),
            _buildSubsectionSkeleton('Employment Type', Assets.icons.workforce.totalPosition.path),
            _buildSubsectionSkeleton('Contract Type', Assets.icons.leaveManagement.shield.path),
            _buildSubsectionSkeleton('Gender / Religion / Marital Status', Assets.icons.employeesBlueIcon.path),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsectionSkeleton(String title, String iconPath) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(title: title, iconPath: iconPath, isDark: isDark),
          Row(
            spacing: 12.w,
            children: List.generate(
              3,
              (index) => const Expanded(
                child: IgnorePointer(child: DigifyCheckbox(value: false, label: 'Option Name', onChanged: null)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
