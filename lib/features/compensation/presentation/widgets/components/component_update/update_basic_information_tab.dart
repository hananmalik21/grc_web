import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/compensation/domain/models/components/comp_component.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/update_component_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/component_creation_shared.dart';
import 'package:grc/features/compensation/presentation/widgets/components/component_creation/create_new_component_config.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpdateBasicInformationStep extends ConsumerWidget {
  final CompComponent component;
  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;

  const UpdateBasicInformationStep({
    super.key,
    required this.component,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateComponentProvider(component));
    final notifier = ref.read(updateComponentProvider(component).notifier);
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final fromDate = state.effectiveFrom == null
        ? null
        : DateTime(state.effectiveFrom!.year, state.effectiveFrom!.month, state.effectiveFrom!.day);
    final toMinDate = fromDate == null ? todayDate : (fromDate.isAfter(todayDate) ? fromDate : todayDate);

    final statuses = CreateNewComponentConfig.statuses;

    final categoriesAsync = ref.watch(compLookupValuesProvider('SALARY_COMPONENT_CATEGORY'));
    final categories = categoriesAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedCategory = _findLookupByCode(categories, state.category);

    final componentTypesAsync = ref.watch(compLookupValuesProvider('COMPONENT_TYPE'));
    final componentTypes = componentTypesAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedComponentType = _findLookupByCode(componentTypes, state.type);

    final currenciesAsync = ref.watch(compLookupValuesProvider('CURRENCY'));
    final currencies = currenciesAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedCurrency = _findLookupByCode(currencies, state.currency);

    return ComponentCreationPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeaderCard(
            icon: DigifyAsset(
              assetPath: Assets.icons.registrationCardIcon.path,
              width: 17.sp,
              height: 17.sp,
              color: AppColors.primary,
            ),
            title: 'Component Details',
            subtitle: 'Edit the basic properties and classification of this compensation component',
          ),
          Gap(24.h),
          Column(
            children: [
              ComponentCreationResponsiveRow(
                left: DigifyTextField.normal(
                  controller: nameController,
                  labelText: 'Component Name',
                  isRequired: true,
                  hintText: 'e.g., Housing Allowance',
                  onChanged: notifier.setName,
                ),
                right: DigifyTextField.normal(
                  controller: codeController,
                  labelText: 'Component Code',
                  isRequired: true,
                  hintText: 'e.g., HOU-ALL-01',
                  onChanged: notifier.setCode,
                ),
              ),
              Gap(20.h),
              ComponentCreationResponsiveRow(
                left: DigifySelectFieldWithLabel<CompLookupValue>(
                  label: 'Category',
                  hint: categoriesAsync.isLoading ? 'Please wait...' : 'Select category',
                  isRequired: true,
                  items: categories,
                  itemLabelBuilder: (item) => item.valueName,
                  value: selectedCategory,
                  onChanged: categoriesAsync.isLoading ? null : (val) => notifier.setCategory(val?.valueCode),
                ),
                right: DigifySelectFieldWithLabel<CompLookupValue>(
                  label: 'Type',
                  hint: componentTypesAsync.isLoading ? 'Please wait...' : 'Select type',
                  isRequired: true,
                  items: componentTypes,
                  itemLabelBuilder: (item) => item.valueName,
                  value: selectedComponentType,
                  onChanged: componentTypesAsync.isLoading ? null : (val) => notifier.setType(val?.valueCode),
                ),
              ),
              Gap(20.h),
              ComponentCreationResponsiveRow(
                left: DigifySelectFieldWithLabel<CompLookupValue>(
                  label: 'Currency',
                  isRequired: true,
                  items: currencies,
                  itemLabelBuilder: (item) => '${item.valueCode} - ${item.valueName}',
                  value: selectedCurrency,
                  hint: currenciesAsync.isLoading ? 'Please wait...' : 'Select currency',
                  onChanged: currenciesAsync.isLoading ? null : (val) => notifier.setCurrency(val?.valueCode ?? ''),
                ),
                right: DigifySelectFieldWithLabel<String>(
                  label: 'Status',
                  isRequired: true,
                  items: statuses,
                  itemLabelBuilder: (item) => item,
                  value: state.status,
                  onChanged: (val) {
                    if (val != null) notifier.setStatus(val);
                  },
                ),
              ),
              Gap(20.h),
              DigifyTextArea(
                controller: descriptionController,
                labelText: 'Description',
                hintText:
                    'Provide detailed information about this component, its purpose, and how it should be applied...',
                maxLines: 4,
                onChanged: notifier.setDescription,
              ),
              Gap(20.h),
              ComponentCreationResponsiveRow(
                left: DigifyDateField(
                  label: 'Effective From',
                  hintText: 'dd/mm/yyyy',
                  isRequired: true,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  initialDate: state.effectiveFrom,
                  onDateSelected: notifier.setEffectiveFrom,
                ),
                right: DigifyDateField(
                  label: 'Effective To',
                  hintText: 'dd/mm/yyyy',
                  isRequired: false,
                  readOnly: state.effectiveFrom == null,
                  firstDate: toMinDate,
                  lastDate: DateTime(2100),
                  initialDate: state.effectiveTo,
                  onDateSelected: notifier.setEffectiveTo,
                ),
              ),
            ],
          ),
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
