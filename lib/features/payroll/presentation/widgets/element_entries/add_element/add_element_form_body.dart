import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/payroll/application/element_entries/config/add_element_form_config.dart';
import 'package:grc/features/payroll/application/element_entries/providers/add_element_form_provider.dart';
import 'package:grc/features/payroll/application/element_entries/providers/add_element_lookups_provider.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/payroll/application/element_entries/states/add_element_form_state.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_costing_tab.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_details_tabs_section.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_effective_banner.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_entry_details_section.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_general_information_tab.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_metadata_footer.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/sections/add_element_process_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AddElementFormBody extends ConsumerStatefulWidget {
  const AddElementFormBody({super.key});

  @override
  ConsumerState<AddElementFormBody> createState() => _AddElementFormBodyState();
}

class _AddElementFormBodyState extends ConsumerState<AddElementFormBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeForm());
  }

  void _initializeForm() {
    if (!mounted) return;

    final notifier = ref.read(addElementFormProvider.notifier);
    notifier.initializeDefaults(AddElementFormDefaults(creatorType: AddElementFormConfig.defaultCreatorType));
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(addElementFormProvider);
    final formNotifier = ref.read(addElementFormProvider.notifier);
    final employee = ref.watch(elementEntriesTabProvider.select((s) => s.selectedEmployee));
    final assignmentNumber = employee?.assignmentNumber ?? formState.assignmentNumber;
    final employeeGuid = employee?.employeeGuid;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final referenceDate = formState.referenceDate ?? AddElementFormState.defaultEffectiveDate;

    ref.watch(addElementLookupsPreloadProvider);

    ref.listen(elementEntriesTabProvider.select((s) => s.selectedEmployee?.assignmentNumber), (previous, next) {
      if (next == null) return;
      formNotifier.syncAssignmentNumber(next);
    });

    ref.listen(elementEntriesTabProvider.select((s) => s.selectedEmployee?.employeeGuid), (previous, next) {
      if (previous == next) return;
      formNotifier.clearElementComponent();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddElementEffectiveBanner(effectiveDate: referenceDate),
        Gap(sectionSpacing),
        AddElementProcessInfoSection(
          assignmentNumber: assignmentNumber,
          effectiveAsOfDate: formState.effectiveAsOfDate,
          entryType: formState.entryType,
          source: formState.source,
          elementProcessingType: formState.elementProcessingType,
          onEffectiveAsOfDateChanged: formNotifier.setEffectiveAsOfDate,
          onEntryTypeChanged: formNotifier.setEntryType,
          onSourceChanged: formNotifier.setSource,
          onElementProcessingTypeChanged: formNotifier.setElementProcessingType,
        ),
        Gap(sectionSpacing),
        AddElementEntryDetailsSection(
          employeeGuid: employeeGuid,
          elementComponent: formState.elementComponent,
          elementClassification: formState.elementClassification,
          subpriority: formState.subpriority,
          onElementComponentChanged: formNotifier.setElementComponent,
          onElementClassificationChanged: formNotifier.setElementClassification,
          onSubpriorityChanged: formNotifier.setSubpriority,
        ),
        Gap(sectionSpacing),
        AddElementDetailsTabsSection(
          selectedTab: formState.selectedTab,
          onTabSelected: formNotifier.setSelectedTab,
          generalInformationTab: AddElementGeneralInformationTab(
            effectiveStartDate: formState.effectiveStartDate,
            effectiveEndDate: formState.effectiveEndDate,
            creatorType: formState.creatorType,
            processed: formState.processed,
            retroactiveEntry: formState.retroactiveEntry,
            automaticEntry: formState.automaticEntry,
            sequenceNumber: formState.sequenceNumber,
            reason: formState.reason,
            payValue: formState.payValue,
            amount: formState.amount,
            contextSegment: formState.contextSegment,
            onEffectiveStartDateSelected: formNotifier.setEffectiveStartDate,
            onEffectiveEndDateSelected: formNotifier.setEffectiveEndDate,
            onCreatorTypeChanged: formNotifier.setCreatorType,
            onProcessedChanged: formNotifier.setProcessed,
            onRetroactiveChanged: formNotifier.setRetroactiveEntry,
            onAutomaticChanged: formNotifier.setAutomaticEntry,
            onSequenceNumberChanged: formNotifier.setSequenceNumber,
            onReasonChanged: formNotifier.setReason,
            onPayValueChanged: formNotifier.setPayValue,
            onAmountChanged: formNotifier.setAmount,
            onContextSegmentChanged: formNotifier.setContextSegment,
          ),
          costingTab: AddElementCostingTab(
            costAllocationKeyFlexfield: formState.costAllocationKeyFlexfield,
            costingType: formState.costingType,
            accountCode: formState.accountCode,
            costCentre: formState.costCentre,
            showEmptyMessage: !formState.hasCostingOverrides,
            onCostAllocationKeyFlexfieldChanged: formNotifier.setCostAllocationKeyFlexfield,
            onCostingTypeChanged: formNotifier.setCostingType,
            onAccountCodeChanged: formNotifier.setAccountCode,
            onCostCentreChanged: formNotifier.setCostCentre,
          ),
        ),
        Gap(sectionSpacing),
        AddElementMetadataFooter(referenceDate: referenceDate),
      ],
    );
  }
}
