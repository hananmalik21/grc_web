import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/common/app_info_tooltip.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustment_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AdjustmentDetailsSection extends ConsumerWidget {
  final String? adjustmentType;
  final DateTime? effectiveDate;
  final String? reasonCode;
  final String? budgetCode;
  final Function(String) onTypeChanged;
  final Function(DateTime) onDateSelected;
  final Function(String) onReasonChanged;
  final Function(String) onBudgetChanged;

  const AdjustmentDetailsSection({
    super.key,
    this.adjustmentType,
    this.effectiveDate,
    this.reasonCode,
    this.budgetCode,
    required this.onTypeChanged,
    required this.onDateSelected,
    required this.onReasonChanged,
    required this.onBudgetChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final adjustmentTypesAsync = ref.watch(adjustmentTypeLookupProvider);
    final budgetCodesAsync = ref.watch(budgetCodeLookupProvider);
    final reasonCodesAsync = ref.watch(reasonCodeLookupProvider);
    final formState = ref.watch(createAdjustmentFormProvider);
    final hireDateStr = formState.hireDate != null ? DateFormat('dd/MM/yyyy').format(formState.hireDate!) : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.compensation.calculator.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(8.w),
              Text(
                'Adjustment Details',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(24.h),
          if (context.isMobileLayout) ...[
            _buildLookupField(
              label: 'Adjustment Type',
              asyncValue: adjustmentTypesAsync,
              currentValue: adjustmentType,
              hint: 'Select Adjustment Type',
              onChanged: onTypeChanged,
            ),
            Gap(16.h),
            DigifyDateField(
              label: 'Effective Date',
              isRequired: true,
              hintText: 'dd/mm/yyyy',
              initialDate: effectiveDate,
              firstDate: formState.hireDate,
              lastDate: DateTime(DateTime.now().year + 5),
              onDateSelected: onDateSelected,
              suffixIcon: AppInfoTooltip(
                message: hireDateStr != null
                    ? 'Effective start date must be on or after the employee\'s hire date ($hireDateStr)'
                    : 'Loading hire date constraint...',
              ),
            ),
            Gap(16.h),
            _buildLookupField(
              label: 'Reason Code',
              asyncValue: reasonCodesAsync,
              currentValue: reasonCode,
              hint: 'Select Reason Code',
              onChanged: onReasonChanged,
            ),
            Gap(16.h),
            _buildLookupField(
              label: 'Budget Code',
              asyncValue: budgetCodesAsync,
              currentValue: budgetCode,
              hint: 'Select Budget Code',
              onChanged: onBudgetChanged,
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildLookupField(
                    label: 'Adjustment Type',
                    asyncValue: adjustmentTypesAsync,
                    currentValue: adjustmentType,
                    hint: 'Select Adjustment Type',
                    onChanged: onTypeChanged,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: DigifyDateField(
                    label: 'Effective Date',
                    isRequired: true,
                    hintText: 'dd/mm/yyyy',
                    initialDate: effectiveDate,
                    firstDate: formState.hireDate,
                    lastDate: DateTime(DateTime.now().year + 5),
                    onDateSelected: onDateSelected,
                    suffixIcon: AppInfoTooltip(
                      message: hireDateStr != null
                          ? 'Effective start date must be on or after the employee\'s hire date ($hireDateStr)'
                          : 'Loading hire date constraint...',
                    ),
                  ),
                ),
              ],
            ),
            Gap(24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildLookupField(
                    label: 'Reason Code',
                    asyncValue: reasonCodesAsync,
                    currentValue: reasonCode,
                    hint: 'Select Reason Code',
                    onChanged: onReasonChanged,
                  ),
                ),
                Gap(24.w),
                Expanded(
                  child: _buildLookupField(
                    label: 'Budget Code',
                    asyncValue: budgetCodesAsync,
                    currentValue: budgetCode,
                    hint: 'Select Budget Code',
                    onChanged: onBudgetChanged,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLookupField({
    required String label,
    required AsyncValue<List<CompLookupValue>> asyncValue,
    required String? currentValue,
    required String hint,
    required Function(String) onChanged,
  }) {
    return asyncValue.when(
      data: (types) => DigifySelectFieldWithLabel<String>(
        label: label,
        value: types.any((e) => e.valueCode == currentValue) ? currentValue : null,
        items: types.map((e) => e.valueCode).toList(),
        itemLabelBuilder: (code) => types.firstWhere((e) => e.valueCode == code).valueName,
        isRequired: true,
        hint: hint,
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
      loading: () => DigifySelectFieldWithLabel<String>(
        label: label,
        items: const [],
        itemLabelBuilder: _dummyLabelBuilder,
        isRequired: true,
        hint: hint,
      ),
      error: (_, _) => DigifySelectFieldWithLabel<String>(
        label: label,
        items: const [],
        itemLabelBuilder: _dummyLabelBuilder,
        isRequired: true,
        hint: hint,
      ),
    );
  }

  static String _dummyLabelBuilder(String value) => value;
}
