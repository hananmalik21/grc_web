import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeCompensationFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String selectedDepartment;
  final String selectedRegion;
  final List<String> departmentOptions;
  final List<String> regionOptions;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String?> onRegionChanged;
  final VoidCallback onExportPressed;
  final bool isExporting;

  const EmployeeCompensationFilterBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    required this.selectedDepartment,
    required this.selectedRegion,
    required this.departmentOptions,
    required this.regionOptions,
    required this.onDepartmentChanged,
    required this.onRegionChanged,
    required this.onExportPressed,
    this.isExporting = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField.search(
            controller: searchController,
            hintText: 'Search by name, ID, or position...',
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
                width: 220.w,
                child: DigifySelectField<String>(
                  hint: 'Department',
                  value: selectedDepartment,
                  items: departmentOptions,
                  itemLabelBuilder: (item) => item,
                  onChanged: onDepartmentChanged,
                ),
              ),
              SizedBox(
                width: 220.w,
                child: DigifySelectField<String>(
                  hint: 'Region',
                  value: selectedRegion,
                  items: regionOptions,
                  itemLabelBuilder: (item) => item,
                  onChanged: onRegionChanged,
                ),
              ),
              AppButton(
                label: 'Export',
                onPressed: isExporting ? null : onExportPressed,
                isLoading: isExporting,
                svgPath: Assets.icons.downloadIcon.path,
                backgroundColor: AppColors.shiftExportButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
