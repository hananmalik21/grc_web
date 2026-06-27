import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'eligibility_rule_chip.dart';
import 'eligibility_tab_data.dart';

class EligibilityRuleSectionCard extends StatelessWidget {
  final EligibilityRuleItem item;

  const EligibilityRuleSectionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      constraints: BoxConstraints(minHeight: 110.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.lightDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.sidebarSecondaryText,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (int i = 0; i < item.values.length; i++) ...[
                  EligibilityRuleChip(label: item.values[i]),
                  if (i < item.values.length - 1) Gap(8.w),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
