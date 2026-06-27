import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_radio.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/eligibility_subsection_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioGroupCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final List<String> options;
  final String? selectedValue;
  final bool isDark;
  final void Function(String?)? onChanged;

  const RadioGroupCard({
    super.key,
    required this.title,
    required this.iconPath,
    required this.options,
    required this.selectedValue,
    required this.isDark,
    this.onChanged,
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
              return DigifyRadio<String>(value: option, groupValue: selectedValue, onChanged: onChanged, label: option);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
