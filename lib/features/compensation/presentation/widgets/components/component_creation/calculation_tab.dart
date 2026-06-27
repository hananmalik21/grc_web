import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/widgets/common/section_header_card.dart';
import '../../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../providers/create_new_component_provider.dart';
import 'component_creation_shared.dart';

class CalculationStep extends ConsumerWidget {
  final TextEditingController minController;
  final TextEditingController maxController;
  final TextEditingController formulaNameController;

  const CalculationStep({
    super.key,
    required this.minController,
    required this.maxController,
    required this.formulaNameController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createNewComponentProvider);
    final notifier = ref.read(createNewComponentProvider.notifier);

    final methodsAsync = ref.watch(compLookupValuesProvider('COMP_CALC_METHOD'));
    final methods = methodsAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedMethod = _findLookupByCode(methods, state.calculationMethod);

    final payBasisAsync = ref.watch(compLookupValuesProvider('PAY_BASIS'));
    final payBasisItems = payBasisAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedPayBasis = _findLookupByCode(payBasisItems, state.payBasis);

    final baseSourcesAsync = ref.watch(compLookupValuesProvider('BASE_AMOUNT_SOURCE'));
    final baseSources = baseSourcesAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedBaseSource = _findLookupByCode(baseSources, state.baseAmountSource);

    final calcMethodCode = state.calculationMethod?.trim();
    final showBaseAmountSource = calcMethodCode == 'PERCENTAGE';
    final showFormulaName = calcMethodCode == 'FORMULA';

    return ComponentCreationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderCard(
            icon: DigifyAsset(
              assetPath: Assets.icons.compensation.calculator.path,
              width: 17.sp,
              height: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Calculation Method',
            subtitle: 'Configure how this component value is calculated',
          ),
          Gap(24.h),

          DigifySelectFieldWithLabel<CompLookupValue>(
            label: 'Calculation Method',
            hint: methodsAsync.isLoading ? 'Please wait...' : 'Select calculation method',
            isRequired: true,
            items: methods,
            itemLabelBuilder: (item) => item.valueName,
            value: selectedMethod,
            onChanged: methodsAsync.isLoading
                ? null
                : (val) {
                    notifier.setCalculationMethod(val?.valueCode);
                    // Keep controllers in sync with the state clearing logic.
                    if (val?.valueCode != 'FORMULA') formulaNameController.clear();
                  },
          ),
          Gap(24.h),

          DigifySelectFieldWithLabel<CompLookupValue>(
            label: 'Pay Basis',
            hint: payBasisAsync.isLoading ? 'Please wait...' : 'Select pay basis',
            items: payBasisItems,
            itemLabelBuilder: (item) => item.valueName,
            value: selectedPayBasis,
            onChanged: payBasisAsync.isLoading ? null : (val) => notifier.setPayBasis(val?.valueCode),
          ),
          Gap(24.h),

          if (showBaseAmountSource) ...[
            DigifySelectFieldWithLabel<CompLookupValue>(
              label: 'Base Amount Source',
              hint: baseSourcesAsync.isLoading ? 'Please wait...' : 'Select base amount source',
              isRequired: true,
              items: baseSources,
              itemLabelBuilder: (item) => item.valueName,
              value: selectedBaseSource,
              onChanged: baseSourcesAsync.isLoading ? null : (val) => notifier.setBaseAmountSource(val?.valueCode),
            ),
            Gap(24.h),
          ],

          if (showFormulaName) ...[
            DigifyTextField.normal(
              controller: formulaNameController,
              labelText: 'Formula Name',
              isRequired: true,
              hintText: 'e.g., Housing Allowance Formula',
              onChanged: notifier.setFormulaName,
            ),
            Gap(24.h),
          ],

          ComponentCreationResponsiveRow(
            left: DigifyTextField(
              controller: minController,
              labelText: 'Minimum Value',
              isRequired: true,
              hintText: 'Enter minimum value',
              keyboardType: FieldFormat.decimal,
              inputFormatters: FieldFormat.decimalTwoPlaces,
              onChanged: notifier.setMinValue,
              filled: true,
              fillColor: Colors.transparent,
            ),
            right: DigifyTextField(
              controller: maxController,
              labelText: 'Maximum Value',
              isRequired: true,
              hintText: 'Enter maximum value',
              keyboardType: FieldFormat.decimal,
              inputFormatters: FieldFormat.decimalTwoPlaces,
              onChanged: notifier.setMaxValue,
              filled: true,
              fillColor: Colors.transparent,
            ),
          ),
          Gap(24.h),
        ],
      ),
    );
  }
}

CompLookupValue? _findLookupByCode(List<CompLookupValue> items, String? code) {
  if (code == null || code.trim().isEmpty) return null;
  final needle = code.trim();
  for (final item in items) {
    if (item.valueCode == needle) return item;
  }
  return null;
}
