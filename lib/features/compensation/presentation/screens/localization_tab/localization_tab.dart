import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../widgets/localization/component_header.dart';
import '../../widgets/localization/component_statuses.dart';
import '../../widgets/localization/component_sub_component_section.dart';
import '../../widgets/localization/component_summary_section.dart';

class LocalizationTab extends ConsumerStatefulWidget {
  const LocalizationTab({super.key});

  @override
  ConsumerState<LocalizationTab> createState() => _LocalizationTabState();
}

class _LocalizationTabState extends ConsumerState<LocalizationTab> {
  String? selectedCountry = 'Kuwait - GCC';

  final List<String> countries = [
    'Kuwait - GCC',
    'Saudi Arabia - GCC',
    'United Arab Emirates - GCC',
    'Qatar - GCC',
    'Oman - GCC',
    'Bahrain - GCC',
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollableSingleChildScrollView(
      scrollDirection: Axis.vertical,
      thickness: 10.w, // Thicker vertical scrollbar for the entire page
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ComponentHeader(),
                Gap(24.h),
                Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.public, color: AppColors.sidebarCategoryText, size: 20.sp),
                        Gap(8.w),
                        Text(
                          'SELECT COUNTRY',
                          style: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Gap(16.w),
                        SizedBox(
                          width: 350.w,
                          child: DigifySelectField<String>(
                            items: countries,
                            value: selectedCountry,
                            itemLabelBuilder: (item) => item,
                            onChanged: (value) => setState(() => selectedCountry = value),
                          ),
                        ),
                      ],
                    ),
                    Gap(16.w),
                    Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                        border: Border.all(color: context.isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Status:', style: context.textTheme.labelMedium),
                          Gap(8.w),
                          DigifyCapsule(
                            label: 'Active',
                            textColor: AppColors.success,
                            backgroundColor: AppColors.success.withValues(alpha: .1),
                          ),
                        ],
                      ),
                    ),
                    Gap(16.w),
                    Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                        border: Border.all(color: context.isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Currency:', style: context.textTheme.labelMedium),
                          Gap(8.w),
                          Text('KWD', style: context.textTheme.labelLarge),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(24.h),
                const ComponentStatuses(),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(24.w),
            width: double.infinity,
            color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (context.isMobile) {
                  return Column(
                    children: [const ComponentSubComponentSection(), Gap(24.h), const ComponentSummarySection()],
                  );
                } else {
                  return Transform.scale(
                    scaleY: -1,
                    child: ScrollableSingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      thumbVisibility: false,
                      padding: EdgeInsets.only(bottom: 10.h),
                      thickness: 8.h,
                      child: Transform.scale(
                        scaleY: -1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
                              child: const ComponentSubComponentSection(),
                            ),
                            Gap(24.w),
                            const ComponentSummarySection(),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
