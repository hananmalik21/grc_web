import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EnterpriseFiltersCard extends StatelessWidget {
  final bool isDark;

  const EnterpriseFiltersCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6.r)),
                child: DigifyAsset(assetPath: Assets.icons.attendance.enterprise.path, width: 20, height: 20, color: AppColors.primary),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enterprise Structure Filters',
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle),
                    ),
                    Text(
                      'Filter attendance by organizational hierarchy',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(24.h),
          Wrap(
            spacing: 14.w,
            runSpacing: 14.h,
            children: [
              SizedBox(
                width: context.isMobile ? (context.deviceWidth - 112.w) : (context.deviceWidth - 160.w) / 4,
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Company',
                  items: const ['All Companies'],
                  itemLabelBuilder: (item) => item,
                  hint: 'Select Company',
                  value: 'All Companies',

                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                width: context.isMobile ? (context.deviceWidth - 112.w) : (context.deviceWidth - 160.w) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigifySelectFieldWithLabel<String>(
                      label: 'Division',
                      items: const ['All Divisions'],
                      itemLabelBuilder: (item) => item,
                      hint: 'Select Division',
                      value: 'All Divisions',
                      onChanged: (value) {},
                      bgColor: AppColors.cardBackgroundGrey,
                    ),
                    Gap(4.h),
                    Text(
                      'Select a company first',
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: context.isMobile ? (context.deviceWidth - 112.w) : (context.deviceWidth - 160.w) / 4,
                child: DigifySelectFieldWithLabel<String>(
                  label: 'Department',
                  items: const ['All Departments'],
                  itemLabelBuilder: (item) => item,
                  hint: 'Select Department',
                  value: 'All Departments',
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                width: context.isMobile ? (context.deviceWidth - 112.w) : (context.deviceWidth - 160.w) / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DigifySelectFieldWithLabel<String>(
                      label: 'Section',
                      items: const ['All Sections'],
                      itemLabelBuilder: (item) => item,
                      hint: 'Select Section',
                      value: 'All Sections',
                      bgColor: AppColors.cardBackgroundGrey,
                      onChanged: (value) {},
                    ),
                    Gap(4.h),
                    Text(
                      'Select a division first',
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
