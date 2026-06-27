import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class ReviewPublishForm extends ConsumerStatefulWidget {
  const ReviewPublishForm({super.key});

  @override
  ConsumerState<ReviewPublishForm> createState() => _ReviewPublishFormState();
}

class _ReviewPublishFormState extends ConsumerState<ReviewPublishForm> {
  String? _selectedStatus = 'Draft - Not visible to users';

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(24.w),
            child: SectionHeaderCard(
              icon: Icon(
                Icons.fact_check_outlined,
                size: 17.sp,
                color: AppColors.primary,
              ),
              title: 'Review Configuration',
              subtitle: 'Review all settings before creating the country rule',
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information Review
                _buildSectionTitle(
                  context,
                  Icons.public,
                  'Basic Information',
                  isDark,
                ),
                Gap(16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.cardBackgroundGreyDark
                        : AppColors.grayBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataField(
                              context,
                              'Country Code',
                              '-',
                              isDark,
                            ),
                            Gap(16.h),
                            _buildDataField(
                              context,
                              'Region',
                              'Middle East',
                              isDark,
                            ),
                          ],
                        ),
                      ),
                      Gap(24.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDataField(
                              context,
                              'Country Name',
                              '-',
                              isDark,
                            ),
                            Gap(16.h),
                            _buildDataField(context, 'Currency', '-', isDark),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(32.h),

                // Salary Structure Review
                _buildSectionTitle(
                  context,
                  Icons.attach_money,
                  'Salary Structure',
                  isDark,
                ),
                Gap(16.h),
                Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : AppColors.infoBg,
                    border: Border.all(
                      color: isDark
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : AppColors.infoBorder,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                Gap(32.h),

                // Statutory Benefits Review
                _buildSectionTitle(
                  context,
                  Icons.shield_outlined,
                  'Statutory Benefits (0 enabled)',
                  isDark,
                ),
                Gap(12.h),
                Text(
                  'No statutory benefits enabled',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                Gap(32.h),

                // Notes
                Text(
                  'Configuration Notes (Optional)',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
                  ),
                ),
                Gap(12.h),
                DigifyTextArea(
                  hintText:
                      'Add any additional notes or special considerations for this country configuration...',
                  maxLines: 4,
                ),
                Gap(24.h),

                // Initial Status
                DigifySelectFieldWithLabel<String>(
                  label: 'Initial Status',
                  items: const ['Draft - Not visible to users', 'Active'],
                  itemLabelBuilder: (item) => item,
                  value: _selectedStatus,
                  onChanged: (value) => setState(() => _selectedStatus = value),
                ),
                Gap(24.h),

                // Next Steps Banner
                _buildInfoBanner(context, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    IconData icon,
    String title,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
        Gap(8.w),
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildDataField(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondary,
            fontSize: 12.sp,
          ),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        border: Border.all(
          color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.primary, size: 20.sp),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Next Steps',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(4.h),
                Text(
                  'After creating this country rule, you can configure detailed salary components, statutory benefits, tax slabs, and other localization settings in the Compensation Localization page.',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
