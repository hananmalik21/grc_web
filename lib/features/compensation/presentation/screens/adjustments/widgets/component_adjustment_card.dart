import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustment_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/common/compensation_component_type_badge.dart';
import 'package:grc/features/compensation/presentation/widgets/common/range_warning_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentAdjustmentCard extends ConsumerWidget {
  final int index;
  final ComponentAdjustment adjustment;
  final CreateAdjustmentFormNotifier notifier;
  final bool isDark;
  final bool isNew;

  const ComponentAdjustmentCard({
    super.key,
    required this.index,
    required this.adjustment,
    required this.notifier,
    required this.isDark,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adjustmentMethodAsync = ref.watch(adjustmentMethodLookupProvider);
    final formState = ref.watch(createAdjustmentFormProvider);

    final isEarning = adjustment.sourceComponent.categoryCode.toUpperCase() == 'EARNING';
    final budgetedMin = isEarning ? formState.budgetedMinKd : null;
    final budgetedMax = isEarning ? formState.budgetedMaxKd : null;

    String? rangeWarning;
    if (isEarning && adjustment.newAmount > 0) {
      if (budgetedMin != null && adjustment.newAmount < budgetedMin) {
        rangeWarning = 'Amount is below the minimum budget of ${budgetedMin.toStringAsFixed(0)} KD';
      } else if (budgetedMax != null && adjustment.newAmount > budgetedMax) {
        rangeWarning = 'Amount exceeds the maximum budget of ${budgetedMax.toStringAsFixed(0)} KD';
      }
    }

    final methodSection = adjustmentMethodAsync.when(
      data: (methods) => _buildAdjustmentMethodField(methods),
      loading: _buildAdjustmentMethodLoadingField,
      error: (_, _) => _buildAdjustmentMethodLoadingField(),
    );

    final valueSection = DigifyTextField(
      labelText: 'Value',
      hintText: _buildValueHint(adjustment.adjustmentType, adjustment.currency),
      initialValue: adjustment.value,
      onChanged: (value) {
        notifier.updateComponentAdjustment(index, isNew: isNew, value: value);
      },
    );

    final amountSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField(
          key: ValueKey('new_amount_${adjustment.newAmountDisplayKey}'),
          labelText: 'NEW AMOUNT',
          readOnly: true,
          initialValue: adjustment.formattedNewAmount,
        ),
        if (isEarning && budgetedMin != null && budgetedMax != null) ...[
          Gap(4.h),
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 12.w, color: AppColors.grayBorderDark),
              Gap(4.w),
              Expanded(
                child: Text(
                  'Allowed range: ${budgetedMin.toStringAsFixed(0)} – ${budgetedMax.toStringAsFixed(0)} KD',
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: AppColors.grayBorderDark),
                ),
              ),
            ],
          ),
        ],
      ],
    );

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        adjustment.componentName,
                        style: context.textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Gap(8.w),
                    CompensationComponentTypeBadge(type: adjustment.componentType),
                  ],
                ),
              ),
              if (!context.isMobileLayout) ...[
                Gap(8.w),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Current: ',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                        ),
                      ),
                      TextSpan(
                        text: adjustment.formattedCurrentAmount,
                        style: context.textTheme.labelLarge?.copyWith(
                          fontSize: 14.sp,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          if (context.isMobileLayout) ...[
            Gap(8.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Current: ',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
                    ),
                  ),
                  TextSpan(
                    text: adjustment.formattedCurrentAmount,
                    style: context.textTheme.labelLarge?.copyWith(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Gap(16.h),
          if (context.isMobileLayout) ...[
            methodSection,
            Gap(16.h),
            valueSection,
            Gap(16.h),
            amountSection,
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: methodSection),
                Gap(12.w),
                Expanded(child: valueSection),
                Gap(12.w),
                Expanded(child: amountSection),
              ],
            ),
          ],
          if (rangeWarning != null) ...[Gap(12.h), RangeWarningCard(message: rangeWarning)],
          Gap(16.h),
          AppButton.text(
            label: 'Remove Component',
            onPressed: () => notifier.removeComponentAdjustment(index, isNew: isNew),
            svgAssetColor: AppColors.alertCritical,
            foregroundColor: AppColors.alertCritical,
            svgPath: Assets.icons.deleteIconRed.path,
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentMethodField(List<CompLookupValue> methods) {
    return DigifySelectFieldWithLabel<String>(
      label: 'Adjustment Type',
      value: methods.any((e) => e.valueCode == adjustment.adjustmentType) ? adjustment.adjustmentType : null,
      items: methods.map((e) => e.valueCode).toList(),
      itemLabelBuilder: (code) => methods.firstWhere((e) => e.valueCode == code).valueName,
      onChanged: (value) {
        if (value != null) {
          notifier.updateComponentAdjustment(index, isNew: isNew, adjustmentType: value);
        }
      },
    );
  }

  Widget _buildAdjustmentMethodLoadingField() {
    return DigifySelectFieldWithLabel<String>(
      label: 'Adjustment Type',
      items: const [],
      itemLabelBuilder: (value) => value,
      hint: 'Loading adjustment methods...',
      onChanged: null,
    );
  }

  String _buildValueHint(String methodCode, String currencyCode) {
    final method = AdjustmentMethod.fromCode(methodCode);
    switch (method) {
      case AdjustmentMethod.percentage:
        return 'Enter percentage value';
      case AdjustmentMethod.amount:
      case AdjustmentMethod.manual:
        return 'Enter value in $currencyCode';
      case null:
        return 'Enter value...';
    }
  }
}
