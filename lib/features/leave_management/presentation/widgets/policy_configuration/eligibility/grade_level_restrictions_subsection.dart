import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradeLevelRestrictionsSubsection extends StatelessWidget {
  final EligibilityCriteria eligibility;
  final bool isDark;

  const GradeLevelRestrictionsSubsection({super.key, required this.eligibility, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(
            title: 'Grade/Level Restrictions (Optional)',
            iconPath: Assets.icons.workforce.fillRate.path,
            isDark: isDark,
          ),
          DigifyTextField(
            controller: TextEditingController(text: eligibility.gradesRestriction ?? ''),
            hintText: 'e.g., Senior, Manager, Executive (leave empty for all grades)',
            filled: true,
            fillColor: AppColors.cardBackground,
          ),
          Text(
            'Comma-separated list of eligible grades',
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
