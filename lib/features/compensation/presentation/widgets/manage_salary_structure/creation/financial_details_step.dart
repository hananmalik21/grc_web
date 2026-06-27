import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../providers/lookups/manage_salary_structure_lookups_provider.dart';
import '../../../providers/salary_structure_creation_provider.dart';

class FinancialDetailsStep extends ConsumerWidget {
  const FinancialDetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final currencyDropdown = ref.watch(manageSalaryStructureCurrencyDropdownProvider);
    final maxSelectableDate = DateTime(2100, 12, 31);

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
          if (context.isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.h,
              children: [
                DigifySelectFieldWithLabel<String>(
                  label: 'Currency',
                  isRequired: true,
                  hint: currencyDropdown.hint,
                  items: currencyDropdown.items,
                  value: state.currency,
                  itemLabelBuilder: currencyDropdown.labelFor,
                  onChanged: (val) => notifier.updateFinancialDetails(currency: val),
                ),
                Text('Primary currency for this structure', style: context.textTheme.labelSmall),
              ],
            ),
            Gap(18.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.h,
              children: [
                DigifyTextField(
                  labelText: 'Cost Center',
                  isRequired: true,
                  hintText: 'e.g., CC-KWT-001',
                  initialValue: state.costCenter,
                  onChanged: (val) => notifier.updateFinancialDetails(costCenter: val),
                ),
                Text('Cost center for budget allocation', style: context.textTheme.labelSmall),
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
                      DigifySelectFieldWithLabel<String>(
                        label: 'Currency',
                        isRequired: true,
                        hint: currencyDropdown.hint,
                        items: currencyDropdown.items,
                        value: state.currency,
                        itemLabelBuilder: currencyDropdown.labelFor,
                        onChanged: (val) => notifier.updateFinancialDetails(currency: val),
                      ),
                      Text('Primary currency for this structure', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      DigifyTextField(
                        labelText: 'Cost Center',
                        isRequired: true,
                        hintText: 'e.g., CC-KWT-001',
                        initialValue: state.costCenter,
                        onChanged: (val) => notifier.updateFinancialDetails(costCenter: val),
                      ),
                      Text('Cost center for budget allocation', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
          ],
          Gap(18.h),
          if (context.isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.h,
              children: [
                DigifyDateField(
                  label: 'Effective From',
                  isRequired: true,
                  hintText: 'dd/mm/yyyy',
                  initialDate: state.effectiveFrom,
                  lastDate: maxSelectableDate,
                  onDateSelected: (val) => notifier.updateFinancialDetails(effectiveFrom: val),
                ),
                Text('Start date for this structure', style: context.textTheme.labelSmall),
              ],
            ),
            Gap(18.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6.h,
              children: [
                DigifyDateField(
                  label: 'Effective To',
                  hintText: state.effectiveFrom == null ? 'Select Effective From first' : 'dd/mm/yyyy',
                  initialDate: state.effectiveTo,
                  isRequired: false,
                  readOnly: state.effectiveFrom == null,
                  firstDate: state.effectiveFrom,
                  lastDate: maxSelectableDate,
                  onDateSelected: (val) => notifier.updateFinancialDetails(effectiveTo: val),
                ),
                Text('End date for this structure (optional)', style: context.textTheme.labelSmall),
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
                      DigifyDateField(
                        label: 'Effective From',
                        isRequired: true,
                        hintText: 'dd/mm/yyyy',
                        initialDate: state.effectiveFrom,
                        lastDate: maxSelectableDate,
                        onDateSelected: (val) => notifier.updateFinancialDetails(effectiveFrom: val),
                      ),
                      Text('Start date for this structure', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
                Gap(18.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6.h,
                    children: [
                      DigifyDateField(
                        label: 'Effective To',
                        hintText: state.effectiveFrom == null ? 'Select Effective From first' : 'dd/mm/yyyy',
                        initialDate: state.effectiveTo,
                        isRequired: false,
                        readOnly: state.effectiveFrom == null,
                        firstDate: state.effectiveFrom,
                        lastDate: maxSelectableDate,
                        onDateSelected: (val) => notifier.updateFinancialDetails(effectiveTo: val),
                      ),
                      Text('End date for this structure (optional)', style: context.textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            ),
          ],
          Gap(18.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 6.h,
            children: [
              DigifyTextField(
                labelText: 'Annual Budget Allocation',
                isRequired: true,
                hintText: 'e.g., 1000000',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                initialValue: state.annualBudget,
                onChanged: (val) => notifier.updateFinancialDetails(annualBudget: val),
              ),
              Text('Total annual budget allocated for this salary structure', style: context.textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}
