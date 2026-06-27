import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class StatutoryComplianceForm extends ConsumerStatefulWidget {
  const StatutoryComplianceForm({super.key});

  @override
  ConsumerState<StatutoryComplianceForm> createState() =>
      _StatutoryComplianceFormState();
}

class _StatutoryComplianceFormState
    extends ConsumerState<StatutoryComplianceForm> {
  // State for the 5 basic statutory benefits (all initially false)
  final Map<String, bool> _basicBenefits = {
    'End of Service Gratuity': false,
    'Annual Leave Encashment': false,
    'Social Insurance (Nationals)': false,
    'Medical Insurance (Mandatory)': false,
    'Work Permit Costs (Expatriates)': false,
  };

  // State for the 3 main system enable flags (initially true as per design)
  bool _enableEosg = true;
  bool _enableIncomeTax = true;
  bool _enablePension = true;

  String? _selectedTaxSystem;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(24.w),
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
          SectionHeaderCard(
            icon: Icon(
              Icons.shield_outlined,
              size: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Statutory Benefits & Compliance',
            subtitle:
                'Configure mandatory statutory benefits and compliance requirements for Middle East',
          ),
          Gap(24.h),

          Text(
            'Enable Statutory Benefits',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),

          // Render 5 basic benefit checkboxes inside grey containers
          ..._basicBenefits.keys.map((title) {
            return _buildGreyCheckboxRow(
              title: title,
              value: _basicBenefits[title]!,
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _basicBenefits[title] = val;
                  });
                }
              },
              isDark: isDark,
            );
          }),
          Gap(8.h),

          // Row of 3 larger system checkboxes
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 600;

              if (isWide) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildGreyCheckboxBox(
                        title: 'Enable End of Service\nGratuity',
                        value: _enableEosg,
                        onChanged: (val) {
                          if (val != null) setState(() => _enableEosg = val);
                        },
                        isDark: isDark,
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: _buildGreyCheckboxBox(
                        title: 'Enable Income Tax System',
                        value: _enableIncomeTax,
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _enableIncomeTax = val);
                          }
                        },
                        isDark: isDark,
                      ),
                    ),
                    Gap(16.w),
                    Expanded(
                      child: _buildGreyCheckboxBox(
                        title: 'Enable Pension Scheme',
                        value: _enablePension,
                        onChanged: (val) {
                          if (val != null) setState(() => _enablePension = val);
                        },
                        isDark: isDark,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildGreyCheckboxBox(
                      title: 'Enable End of Service Gratuity',
                      value: _enableEosg,
                      onChanged: (val) {
                        if (val != null) setState(() => _enableEosg = val);
                      },
                      isDark: isDark,
                    ),
                    Gap(16.h),
                    _buildGreyCheckboxBox(
                      title: 'Enable Income Tax System',
                      value: _enableIncomeTax,
                      onChanged: (val) {
                        if (val != null) setState(() => _enableIncomeTax = val);
                      },
                      isDark: isDark,
                    ),
                    Gap(16.h),
                    _buildGreyCheckboxBox(
                      title: 'Enable Pension Scheme',
                      value: _enablePension,
                      onChanged: (val) {
                        if (val != null) setState(() => _enablePension = val);
                      },
                      isDark: isDark,
                    ),
                  ],
                );
              }
            },
          ),
          Gap(24.h),

          // Tax System Type
          DigifySelectFieldWithLabel<String>(
            label: 'Tax System Type',
            hint: 'Select tax system type',
            items: const ['Progressive Tax', 'Flat Rate Tax', 'Exempt'],
            itemLabelBuilder: (item) => item,
            value: _selectedTaxSystem,
            onChanged: (value) => setState(() => _selectedTaxSystem = value),
          ),
          Gap(24.h),

          // Overtime Rules Text Area
          DigifyTextArea(
            labelText: 'Overtime Rules',
            hintText:
                'Describe overtime calculation rules and rates (e.g., 1.5x for weekdays, 2x for weekends)',
            maxLines: 4,
          ),
          Gap(24.h),

          // Compliance Ready Banner
          _buildComplianceReadyBanner(isDark),
        ],
      ),
    );
  }

  Widget _buildGreyCheckboxRow({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: DigifyCheckbox(
        value: value,
        onChanged: onChanged,
        labelWidget: Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildGreyCheckboxBox({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyCheckbox(value: value, onChanged: onChanged),
          Gap(12.w),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceReadyBanner(bool isDark) {
    int selectedCount = _basicBenefits.values.where((v) => v).length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark : AppColors.greenBg,
        border: Border.all(
          color: isDark ? AppColors.successBorderDark : AppColors.greenBorder,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            color: isDark ? AppColors.successTextDark : AppColors.greenText,
            size: 20.sp,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Compliance Ready',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.successTextDark
                        : AppColors.greenText,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(4.h),
                Text(
                  "You've selected $selectedCount statutory benefits for Middle East. These can be configured in detail after creating the country rule.",
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.successTextDark
                        : AppColors.greenTextSecondary,
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
