import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxGroupCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final List<String> options;
  final List<String> selectedValues;
  final bool isDark;
  final void Function(String, bool)? onToggle;

  const CheckboxGroupCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.options,
    required this.selectedValues,
    required this.isDark,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.categoryBadgeBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          EligibilitySubsectionHeader(title: title, iconPath: iconPath, isDark: isDark),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8.h,
            children: options.map((option) {
              return DigifyCheckbox(
                value: selectedValues.contains(option),
                onChanged: onToggle != null ? (checked) => onToggle!(option, checked ?? false) : null,
                label: option,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
