import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_owner_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_compensation_plan_config.dart';
import 'create_compensation_plan_section_card.dart';

class CreateCompensationPlanDetailsStep extends ConsumerStatefulWidget {
  const CreateCompensationPlanDetailsStep({super.key});

  @override
  ConsumerState<CreateCompensationPlanDetailsStep> createState() => _CreateCompensationPlanDetailsStepState();
}

class _CreateCompensationPlanDetailsStepState extends ConsumerState<CreateCompensationPlanDetailsStep> {
  late final TextEditingController _planNameController;
  late final TextEditingController _planCodeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _budgetAmountController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createCompensationPlanProvider);
    _planNameController = TextEditingController(text: state.planName);
    _planCodeController = TextEditingController(text: state.planCode);
    _descriptionController = TextEditingController(text: state.description);
    _budgetAmountController = TextEditingController(text: state.budgetAmount);
  }

  @override
  void dispose() {
    _planNameController.dispose();
    _planCodeController.dispose();
    _descriptionController.dispose();
    _budgetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);
    final ownerState = ref.watch(createCompensationPlanOwnerProvider);
    final ownerNotifier = ref.read(createCompensationPlanOwnerProvider.notifier);
    final enterpriseId = ref.watch(compensationPlansTabEnterpriseIdProvider);
    final planTypesAsync = ref.watch(compensationPlansLookupValuesProvider('PLAN_TYPE'));
    final currenciesAsync = ref.watch(compensationPlansLookupValuesProvider('CURRENCY'));
    final planTypes = planTypesAsync.valueOrNull ?? const <CompLookupValue>[];
    final currencies = currenciesAsync.valueOrNull ?? const <CompLookupValue>[];
    final selectedPlanType = _findLookupByCode(planTypes, state.planType);
    final selectedCurrency = _findLookupByCode(currencies, state.currency);

    if (ownerState.selectedEmployee != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ownerNotifier.syncWithExpectedOwnerId(state.planOwnerEmployeeId);
      });
    }

    final basicInformationCard = CreateCompensationPlanSectionCard(
      title: 'Basic Information',
      subtitle: 'Core plan configuration and metadata',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField(
            controller: _planNameController,
            labelText: 'Plan Name',
            isRequired: true,
            hintText: 'e.g., Kuwait Standard Plan 2026',
            onChanged: (value) => notifier.updateBasicInformation(planName: value),
          ),
          Gap(16.h),
          DigifyTextField(
            controller: _planCodeController,
            labelText: 'Plan Code',
            isRequired: true,
            hintText: 'e.g., PLAN-KWT-2026',
            onChanged: (value) => notifier.updateBasicInformation(planCode: value),
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<CompLookupValue>(
            label: 'Plan Type',
            isRequired: true,
            value: selectedPlanType,
            hint: planTypesAsync.isLoading ? 'Please wait...' : 'Select plan type',
            items: planTypes,
            itemLabelBuilder: (item) => item.valueName,
            onChanged: (value) {
              if (value == null) return;
              notifier.updateBasicInformation(planType: value.valueCode);
            },
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Status',
            isRequired: true,
            value: state.status,
            hint: 'Select status',
            items: CreateCompensationPlanConfig.statuses,
            itemLabelBuilder: (item) => item,
            onChanged: (value) {
              if (value == null) return;
              notifier.updateBasicInformation(status: value);
            },
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _descriptionController,
            labelText: 'Description',
            isRequired: false,
            hintText: 'Provide a short description about the purpose of this compensation plan...',
            maxLines: 5,
            minLines: 5,
            onChanged: (value) => notifier.updateBasicInformation(description: value),
          ),
        ],
      ),
    );

    final financialDetailsCard = CreateCompensationPlanSectionCard(
      title: 'Financial & Dates',
      subtitle: 'Currency, effective dates, and ownership',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifySelectFieldWithLabel<CompLookupValue>(
            label: 'Currency',
            isRequired: true,
            value: selectedCurrency,
            hint: currenciesAsync.isLoading ? 'Please wait...' : 'Select currency',
            items: currencies,
            itemLabelBuilder: (item) => '${item.valueCode} - ${item.valueName}',
            onChanged: (value) {
              if (value == null) return;
              notifier.updateFinancialAndOwnerDetails(currency: value.valueCode);
            },
          ),
          Gap(16.h),
          DigifyTextField(
            controller: _budgetAmountController,
            labelText: 'Budget Amount',
            hintText: 'e.g., 21060000',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: FieldFormat.decimalTwoPlaces,
            onChanged: (value) => notifier.updateFinancialAndOwnerDetails(budgetAmount: value),
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            DigifyDateField(
              label: 'Effective From',
              isRequired: true,
              hintText: 'Select effective from date',
              initialDate: state.effectiveFrom,
              lastDate: DateTime(2100, 12, 31),
              onDateSelected: (value) => notifier.updateFinancialAndOwnerDetails(effectiveFrom: value),
            ),
            Gap(16.h),
            DigifyDateField(
              label: 'Effective To',
              isRequired: false,
              hintText: state.effectiveFrom == null ? 'Select effective from date first' : 'Select effective to date',
              initialDate: state.effectiveTo,
              firstDate: state.effectiveFrom,
              lastDate: DateTime(2100, 12, 31),
              readOnly: state.effectiveFrom == null,
              onDateSelected: (value) => notifier.updateFinancialAndOwnerDetails(effectiveTo: value),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: DigifyDateField(
                    label: 'Effective From',
                    isRequired: true,
                    hintText: 'Select effective from date',
                    initialDate: state.effectiveFrom,
                    lastDate: DateTime(2100, 12, 31),
                    onDateSelected: (value) => notifier.updateFinancialAndOwnerDetails(effectiveFrom: value),
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyDateField(
                    label: 'Effective To',
                    isRequired: false,
                    hintText: state.effectiveFrom == null
                        ? 'Select effective from date first'
                        : 'Select effective to date',
                    initialDate: state.effectiveTo,
                    firstDate: state.effectiveFrom,
                    lastDate: DateTime(2100, 12, 31),
                    readOnly: state.effectiveFrom == null,
                    onDateSelected: (value) => notifier.updateFinancialAndOwnerDetails(effectiveTo: value),
                  ),
                ),
              ],
            ),
          ],
          Gap(16.h),
          if (enterpriseId != null)
            EmployeeSearchField(
              label: 'Plan Owner',
              isRequired: false,
              enterpriseId: enterpriseId,
              selectedEmployee: ownerState.selectedEmployee,
              hintText: 'Search and select plan owner',
              onEmployeeSelected: (employee) {
                ref.read(createCompensationPlanOwnerProvider.notifier).setSelectedEmployee(employee);
                notifier.setPlanOwnerFromEmployee(employee);
              },
              fillColor: Colors.transparent,
            )
          else
            DigifyTextField(
              labelText: 'Plan Owner',
              isRequired: false,
              hintText: 'Select enterprise first to load employees',
              readOnly: true,
              enabled: false,
            ),
        ],
      ),
    );

    if (context.isMobile) {
      return Column(
        key: const ValueKey('plan-details-step'),
        children: [basicInformationCard, Gap(20.h), financialDetailsCard],
      );
    }

    return Row(
      key: const ValueKey('plan-details-step'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 600.h),
            child: basicInformationCard,
          ),
        ),
        Gap(20.w),
        Expanded(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 600.h),
            child: financialDetailsCard,
          ),
        ),
      ],
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
