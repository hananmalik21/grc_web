import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_compensation_plan_eligibility_layout_widgets.dart';
import 'create_compensation_plan_eligibility_picker_mixin.dart';
import 'create_compensation_plan_org_structure_section.dart';

class CreateCompensationPlanEligibilityStep extends ConsumerStatefulWidget {
  const CreateCompensationPlanEligibilityStep({super.key});

  @override
  ConsumerState<CreateCompensationPlanEligibilityStep> createState() => _CreateCompensationPlanEligibilityStepState();
}

class _CreateCompensationPlanEligibilityStepState extends ConsumerState<CreateCompensationPlanEligibilityStep>
    with CreateCompensationPlanEligibilityPickerMixin {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCompensationPlanProvider);
    final notifier = ref.read(createCompensationPlanProvider.notifier);

    final structureTypesAsync = ref.watch(compensationPlansLookupValuesProvider('SALARY_STRUCTURE_TYPE'));
    final planAttributesAsync = ref.watch(compensationPlansLookupValuesProvider('COMP_PLAN_ATTRUBUTES'));
    final locationsAsync = ref.watch(compensationPlansLookupValuesProvider('COMPONENT_LOCATION'));

    final structureTypes = structureTypesAsync.valueOrNull ?? const <CompLookupValue>[];
    final locations = locationsAsync.valueOrNull ?? const <CompLookupValue>[];

    final selectedStructureType = findLookupByCode(structureTypes, state.eligibilityStructureType);
    final selectedLocation = findLookupByCode(
      locations,
      state.eligibilityLocations.isNotEmpty ? state.eligibilityLocations.first : '',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EligibilitySectionCard(
          key: const ValueKey('plan-eligibility-step-main'),
          title: 'Eligibility & Assignment',
          subtitle: 'Configure rules and assignments for this compensation plan',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifySelectFieldWithLabel<CompLookupValue>(
                label: 'Structure Type',
                hint: structureTypesAsync.isLoading ? 'Please wait...' : 'Select structure type',
                value: selectedStructureType,
                items: structureTypes,
                itemLabelBuilder: (item) => item.valueName,
                onChanged: (value) {
                  if (value == null) return;
                  notifier.updateEligibilityStructureType(value.valueCode);
                },
              ),
              Gap(18.h),
              EligibilityRow(
                left: DigifyMultiSelectFieldWithLabel(
                  label: 'Contract Type',
                  hint: 'Add Contract Type',
                  selectedCount: state.eligibilityContractTypes.length,
                  isEnabled: true,
                  onTap: pickContractTypes,
                ),
                right: DigifyMultiSelectFieldWithLabel(
                  label: 'Plan Attributes',
                  hint: planAttributesAsync.isLoading ? 'Please wait...' : 'Add Plan Attribute',
                  selectedCount: state.eligibilityPlanAttributes.length,
                  isEnabled: !planAttributesAsync.isLoading,
                  onTap: () => pickPlanAttributes(planAttributesAsync),
                ),
              ),
              Gap(18.h),
              EligibilityRow(
                left: DigifyMultiSelectFieldWithLabel(
                  label: 'Job Family',
                  hint: 'Add Job Family',
                  selectedCount: state.eligibilityJobFamilies.length,
                  isEnabled: true,
                  onTap: pickJobFamilies,
                ),
                right: DigifyMultiSelectFieldWithLabel(
                  label: 'Position',
                  hint: 'Add Position',
                  selectedCount: state.eligibilityPositionIds.length,
                  isEnabled: true,
                  onTap: pickPositions,
                ),
              ),
              Gap(18.h),
              EligibilityRow(
                left: DigifyMultiSelectFieldWithLabel(
                  label: 'Grade',
                  hint: 'Add Grade',
                  selectedCount: state.eligibilityGradeIds.length,
                  isEnabled: true,
                  onTap: pickGrades,
                ),
                right: DigifySelectFieldWithLabel<CompLookupValue>(
                  label: 'Location',
                  hint: locationsAsync.isLoading ? 'Please wait...' : 'Select location',
                  value: selectedLocation,
                  items: locations,
                  itemLabelBuilder: (item) => item.valueName,
                  onChanged: (value) {
                    if (value == null) {
                      notifier.setEligibilityLocations([]);
                      return;
                    }
                    notifier.setEligibilityLocations([value.valueCode]);
                  },
                ),
              ),
            ],
          ),
        ),
        Gap(18.h),
        EligibilitySectionCard(
          key: const ValueKey('plan-eligibility-step-org-structure'),
          title: 'Organization & Structure Selection',
          subtitle: 'Configure company and hierarchy-level assignments',
          child: const CreateCompensationPlanOrgStructureSection(),
        ),
      ],
    );
  }
}
