import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdvancedRulesSkeleton extends StatelessWidget {
  final bool isDark;

  const AdvancedRulesSkeleton({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Advanced Rules',
      iconPath: Assets.icons.leaveManagement.filter.path,
      child: Skeletonizer(
        enabled: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 14.h,
          children: [
            _buildSubsectionSkeleton('Days & Notice Period', Icons.timer_outlined, 2),
            _buildSubsectionSkeleton('Weekend / Holiday Inclusion', Icons.calendar_today_outlined, 3),
            _buildSubsectionSkeleton('Supporting Documentation', Icons.description_outlined, 1),
          ],
        ),
      ),
    );
  }

  Widget _buildSubsectionSkeleton(String title, IconData icon, int checkboxCount) {
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
          Row(
            children: [
              Icon(icon, size: 22.sp, color: AppColors.primary),
              Gap(12.w),
              Text(
                title,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Wrap(
            spacing: 24.w,
            runSpacing: 12.h,
            children: List.generate(
              checkboxCount,
              (index) => const IgnorePointer(
                child: DigifyCheckbox(value: false, label: 'Skeleton Option Name Label', onChanged: null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
