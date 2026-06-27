import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PublicHolidaysActionBar extends StatelessWidget {
  final TextEditingController searchController;
  final String selectedYear;
  final String selectedType;
  final List<String> availableYears;
  final List<String> availableTypes;
  final ValueChanged<String?> onYearChanged;
  final ValueChanged<String?> onTypeChanged;
  final ValueChanged<String> onSearchChanged;

  const PublicHolidaysActionBar({
    super.key,
    required this.searchController,
    required this.selectedYear,
    required this.selectedType,
    required this.availableYears,
    required this.availableTypes,
    required this.onYearChanged,
    required this.onTypeChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: searchController,
            hintText: 'Search holidays by name or Arabic name...',
            onChanged: onSearchChanged,
          ),
          Gap(16.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 144.w,
                child: DigifySelectField<String>(
                  hint: 'Year',
                  value: selectedYear,
                  items: availableYears,
                  itemLabelBuilder: (year) => year,
                  onChanged: onYearChanged,
                ),
              ),
              SizedBox(
                width: 144.w,
                child: DigifySelectField<String>(
                  hint: 'Type',
                  value: selectedType,
                  items: availableTypes,
                  itemLabelBuilder: (type) => type,
                  onChanged: onTypeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
