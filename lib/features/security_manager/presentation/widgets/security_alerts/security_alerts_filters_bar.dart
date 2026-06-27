import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityAlertsFiltersBar extends StatelessWidget {
  final bool isDark;
  final TextEditingController searchController;
  final String levelValue;
  final String statusValue;
  final List<String> levels;
  final List<String> statuses;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onLevelChanged;
  final ValueChanged<String?> onStatusChanged;

  const SecurityAlertsFiltersBar({
    super.key,
    required this.isDark,
    required this.searchController,
    required this.levelValue,
    required this.statusValue,
    required this.levels,
    required this.statuses,
    required this.onSearchChanged,
    required this.onLevelChanged,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;

        final searchField = DigifyTextField.search(
          controller: searchController,
          hintText: 'Search alerts by type, message, user, or ID...',
          fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          onChanged: onSearchChanged,
        );
        final levelField = DigifySelectField<String>(
          hint: 'All Levels',
          value: levelValue,
          items: levels,
          itemLabelBuilder: (value) => value,
          onChanged: onLevelChanged,
          fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        );
        final statusField = DigifySelectField<String>(
          hint: 'All Status',
          value: statusValue,
          items: statuses,
          itemLabelBuilder: (value) => value,
          onChanged: onStatusChanged,
          fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        );
        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
            boxShadow: AppShadows.primaryShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchField,
                    Gap(12.h),
                    Row(
                      children: [
                        Expanded(child: levelField),
                        Gap(12.w),
                        Expanded(child: statusField),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 4, child: searchField),
                    Gap(16.w),
                    SizedBox(width: 180.w, child: levelField),
                    Gap(16.w),
                    SizedBox(width: 180.w, child: statusField),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
