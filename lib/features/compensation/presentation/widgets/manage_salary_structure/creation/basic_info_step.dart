import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../providers/lookups/manage_salary_structure_lookups_provider.dart';
import '../../../providers/salary_structure_creation_provider.dart';

class BasicInfoStep extends ConsumerWidget {
  const BasicInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final typeDropdown = ref.watch(manageSalaryStructureTypeDropdownProvider);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6.h,
            children: [
              DigifyTextField(
                labelText: 'Structure Name',
                isRequired: true,
                hintText: 'e.g., Kuwait Standard Salary Structure 2026',
                initialValue: state.name,
                onChanged: (val) => notifier.updateBasicInfo(name: val),
              ),
              Text(
                'Optional: Add context about when and how this structure should be used',
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.h,
              children: [
                DigifyTextField(
                  labelText: 'Structure Code',
                  isRequired: true,
                  hintText: 'e.g., SS-KWT-2026',
                  initialValue: state.code,
                  onChanged: (val) => notifier.updateBasicInfo(code: val),
                ),
                Text('Unique identifier for payroll integration', style: context.textTheme.labelSmall),
              ],
            ),
            Gap(16.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.h,
              children: [
                DigifySelectFieldWithLabel<String>(
                  label: 'Structure Type',
                  isRequired: true,
                  items: typeDropdown.items,
                  hint: typeDropdown.hint,
                  value: state.type,
                  itemLabelBuilder: typeDropdown.labelFor,
                  onChanged: (val) => notifier.updateBasicInfo(type: val),
                ),
                Text('Select the compensation model type', style: context.textTheme.labelSmall),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      DigifyTextField(
                        labelText: 'Structure Code',
                        isRequired: true,
                        hintText: 'e.g., SS-KWT-2026',
                        initialValue: state.code,
                        onChanged: (val) => notifier.updateBasicInfo(code: val),
                      ),
                      Text('Unique identifier for payroll integration', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      DigifySelectFieldWithLabel<String>(
                        label: 'Structure Type',
                        isRequired: true,
                        items: typeDropdown.items,
                        hint: typeDropdown.hint,
                        value: state.type,
                        itemLabelBuilder: typeDropdown.labelFor,
                        onChanged: (val) => notifier.updateBasicInfo(type: val),
                      ),
                      Text('Select the compensation model type', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6.h,
            children: [
              DigifyTextArea(
                labelText: 'Description',
                hintText: 'Provide additional details about this salary structure, its purpose, and applicability...',
                initialValue: state.description,
                onChanged: (val) => notifier.updateBasicInfo(description: val),
              ),
              Text(
                'Optional: Add context about when and how this structure should be used',
                style: context.textTheme.labelSmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
