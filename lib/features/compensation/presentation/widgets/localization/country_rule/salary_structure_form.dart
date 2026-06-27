import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/common/digify_capsule.dart';
import '../../../../../../core/widgets/common/digify_radio.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';

class SalaryTemplateItem {
  final String title;
  final String regionTag;
  final String subtitle;
  final List<String> tags;

  const SalaryTemplateItem({
    required this.title,
    required this.regionTag,
    required this.subtitle,
    required this.tags,
  });
}

const List<SalaryTemplateItem> defaultTemplates = [
  SalaryTemplateItem(
    title: 'GCC Standard',
    regionTag: 'Middle East',
    subtitle: 'Basic + Housing + Transport + Allowances',
    tags: [
      'Basic Salary',
      'Housing Allowance (25%)',
      'Transport Allowance',
      'Mobile Allowance',
      'Medical Insurance',
    ],
  ),
  SalaryTemplateItem(
    title: 'EU Standard',
    regionTag: 'Europe',
    subtitle: 'Base + Benefits Package + Social Contributions',
    tags: [
      'Base Salary',
      'Pension Contribution (15%)',
      'Health Insurance',
      'Meal Vouchers',
      'Transport Subsidy',
    ],
  ),
  SalaryTemplateItem(
    title: 'US Standard',
    regionTag: 'North America',
    subtitle: 'Base + 401k + Benefits + Variable Pay',
    tags: [
      'Base Salary',
      '401k Match (5%)',
      'Healthcare Insurance',
      'Dental & Vision',
      'Performance Bonus',
    ],
  ),
  SalaryTemplateItem(
    title: 'Asia Pacific Standard',
    regionTag: 'Asia Pacific',
    subtitle: 'Base + Statutory Benefits + Local Allowances',
    tags: [
      'Base Salary',
      'CPF/MPF Contribution',
      'Annual Bonus',
      'Transport Allowance',
      'Medical Coverage',
    ],
  ),
  SalaryTemplateItem(
    title: 'Custom Configuration',
    regionTag: 'All Regions',
    subtitle: 'Build from scratch with specific requirements',
    tags: ['To be configured manually'],
  ),
];

class SalaryStructureForm extends ConsumerStatefulWidget {
  const SalaryStructureForm({super.key});

  @override
  ConsumerState<SalaryStructureForm> createState() =>
      _SalaryStructureFormState();
}

class _SalaryStructureFormState extends ConsumerState<SalaryStructureForm> {
  String? _selectedTemplateTitle;

  final _hoursController = TextEditingController(text: '40');
  final _minWageController = TextEditingController();
  String? _selectedFrequency = 'Monthly';

  final List<String> _frequencies = ['Daily', 'Weekly', 'Bi-Weekly', 'Monthly'];

  @override
  void dispose() {
    _hoursController.dispose();
    _minWageController.dispose();
    super.dispose();
  }

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
              Icons.attach_money,
              size: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Salary Structure Template',
            subtitle:
                'Select a pre-configured template or create a custom salary structure',
          ),
          Gap(24.h),

          // Template List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: defaultTemplates.length,
            separatorBuilder: (_, _) => Gap(16.h),
            itemBuilder: (context, index) {
              final template = defaultTemplates[index];
              return _TemplateCard(
                template: template,
                isSelected: _selectedTemplateTitle == template.title,
                onTap: () {
                  setState(() {
                    _selectedTemplateTitle = template.title;
                  });
                },
              );
            },
          ),
          Gap(32.h),

          // Configuration Fields Row
          DigifySelectFieldWithLabel<String>(
            label: 'Payroll Frequency',
            hint: 'Select frequency',
            items: _frequencies,
            itemLabelBuilder: (item) => item,
            value: _selectedFrequency,
            onChanged: (value) => setState(() => _selectedFrequency = value),
          ),
          Gap(20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField.normal(
                  controller: _hoursController,
                  labelText: 'Standard Working Hours/Week',
                ),
              ),
              Gap(24.w),
              Expanded(
                child: DigifyTextField.normal(
                  controller: _minWageController,
                  labelText: 'Minimum Wage (Currency)',
                  hintText: 'Enter minimum wage amount',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final SalaryTemplateItem template;
  final bool isSelected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.infoBg)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        template.title,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                      ),
                      Gap(12.w),
                      DigifyCapsule(
                        label: template.regionTag,
                        backgroundColor: Colors.transparent,
                        textColor: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                        borderColor: isDark
                            ? AppColors.borderGreyDark
                            : AppColors.borderGrey,
                      ),
                    ],
                  ),
                  Gap(8.h),
                  Text(
                    template.subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary,
                    ),
                  ),
                  Gap(12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: template.tags.map((tag) {
                      return DigifyCapsule(
                        label: tag,
                        backgroundColor: isDark
                            ? AppColors.cardBackgroundGreyDark
                            : AppColors.cardBackgroundGrey,
                        textColor: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Gap(16.w),
            DigifyRadio<String>(
              value: template.title,
              groupValue: isSelected ? template.title : null,
            ),
          ],
        ),
      ),
    );
  }
}
