import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../gen/assets.gen.dart';
import 'sections/country_setup.dart';
import 'sections/end_of_service.dart';
import 'sections/pay_policies.dart';
import 'sections/salary_components.dart';
import 'sections/statutory_benefits.dart';
import 'sections/validation_and_publish.dart';

class ComponentSubComponentSection extends ConsumerStatefulWidget {
  const ComponentSubComponentSection({super.key});

  @override
  ConsumerState<ComponentSubComponentSection> createState() =>
      _ComponentSubComponentSectionState();
}

class _ComponentSubComponentSectionState
    extends ConsumerState<ComponentSubComponentSection> {
  final List<Map<String, dynamic>> subTabs = [
    {'label': 'Country Setup', 'icon': Icons.public},
    {
      'label': 'Salary Components',
      'iconPath': Assets.icons.compensation.components.path,
    },
    {
      'label': 'Statutory Benefits',
      'iconPath': Assets.icons.complianceIcon.path,
    },
    {
      'label': 'End of Service / Severance',
      'iconPath': Assets.icons.eosCalculatorIcon.path,
    },
    {'label': 'Pay Policies', 'iconPath': Assets.icons.descriptionIcon.path},
    {
      'label': 'Validation & Publish',
      'iconPath': Assets.icons.activeCheckIcon.path,
    },
  ];
  int activeSubTabIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, top: 8.h, right: 16.w, bottom: 16.h),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.cardBackgroundDark
            : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: context.isDark
              ? AppColors.cardBorderDark
              : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubTabs(context),
          Gap(24.h),
          switch (activeSubTabIndex) {
            0 => CountrySetup(),
            1 => SalaryComponents(),
            2 => StatutoryBenefits(),
            3 => EndOfService(),
            4 => PayPolicies(),
            5 => ValidationAndPublish(),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  Widget _buildSubTabs(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.isDark
                ? AppColors.inputBorderDark
                : AppColors.inputBorder,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: subTabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = activeSubTabIndex == index;

            return GestureDetector(
              onTap: () => setState(() => activeSubTabIndex = index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2.h,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (tab['icon'] != null)
                      Icon(
                        tab['icon'] as IconData,
                        size: 18.sp,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      )
                    else
                      SvgGenImage(tab['iconPath'] as String).svg(
                        width: 18.sp,
                        height: 18.sp,
                        colorFilter: ColorFilter.mode(
                          isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    Gap(8.w),
                    Text(
                      tab['label'] as String,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
