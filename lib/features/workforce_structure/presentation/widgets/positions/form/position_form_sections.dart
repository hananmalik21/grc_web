import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/position_search_field.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/enterprise_structure_fields.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/grade_selection_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/job_family_selection_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/step_selection_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/job_level_selection_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/position_form_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicInfoSection extends StatelessWidget {
  final AppLocalizations localizations;
  final String code;
  final String titleEnglish;
  final String titleArabic;
  final bool isEdit;
  final bool isActive;
  final ValueChanged<String> onCodeChanged;
  final ValueChanged<String> onTitleEnglishChanged;
  final ValueChanged<String> onTitleArabicChanged;
  final ValueChanged<bool?> onStatusChanged;

  const BasicInfoSection({
    super.key,
    required this.localizations,
    required this.code,
    required this.titleEnglish,
    required this.titleArabic,
    required this.onCodeChanged,
    required this.onTitleEnglishChanged,
    required this.onTitleArabicChanged,
    required this.isActive,
    required this.onStatusChanged,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.basicInformation,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: localizations.positionCode,
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: code,
                onChanged: onCodeChanged,
                hint: 'e.g, FIN-MGR-001',
                enabled: !isEdit,
              ),
            ),
            PositionLabeledField(
              label: localizations.status,
              isRequired: true,
              child: PositionFormHelpers.buildDropdownField<bool>(
                value: isActive,
                items: const [true, false],
                onChanged: onStatusChanged,
                itemLabelProvider: (val) => val == true ? localizations.active : localizations.inactive,
              ),
            ),
          ],
        ),
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: '${localizations.positionTitle} (English)',
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: titleEnglish,
                onChanged: onTitleEnglishChanged,
                hint: 'e.g. Finance Manager',
              ),
            ),
            PositionLabeledField(
              label: '${localizations.positionTitle} (Arabic)',
              isRequired: false,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: titleArabic,
                onChanged: onTitleArabicChanged,
                hint: 'e.g. Finance Manager (Optional)',
                inputFormatters: [AppInputFormatters.nameAny],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class OrganizationalSection extends ConsumerWidget {
  final AppLocalizations localizations;
  final Map<String, String?> selectedUnitIds;
  final Map<String, OrgUnit>? initialSelections;
  final Function(String levelCode, String? unitId) onEnterpriseSelectionChanged;
  final String costCenter;
  final String location;
  final ValueChanged<String> onCostCenterChanged;
  final ValueChanged<String> onLocationChanged;

  const OrganizationalSection({
    super.key,
    required this.localizations,
    required this.selectedUnitIds,
    required this.onEnterpriseSelectionChanged,
    required this.costCenter,
    required this.location,
    required this.onCostCenterChanged,
    required this.onLocationChanged,
    this.initialSelections,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PositionDialogSection(
      title: localizations.organizationalInformation,
      children: [
        EnterpriseStructureFields(
          localizations: localizations,
          selectedUnitIds: selectedUnitIds,
          onSelectionChanged: onEnterpriseSelectionChanged,
          initialSelections: initialSelections,
        ),
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: localizations.costCenter,
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: costCenter,
                onChanged: onCostCenterChanged,
                hint: 'e.g., CC-1000',
              ),
            ),
            PositionLabeledField(
              label: localizations.location,
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: location,
                onChanged: onLocationChanged,
                hint: 'e.g., Kuwait City HQ',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class JobClassificationSection extends StatelessWidget {
  final AppLocalizations localizations;

  const JobClassificationSection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.jobClassification,
      children: [
        PositionFormRow(
          children: [
            JobFamilySelectionField(label: localizations.jobFamily),
            JobLevelSelectionField(label: localizations.jobLevel),
            GradeSelectionField(label: localizations.grade),
          ],
        ),
        PositionFormRow(children: [StepSelectionField(label: localizations.step)]),
      ],
    );
  }
}

class HeadcountSection extends ConsumerWidget {
  final AppLocalizations localizations;
  final String positions;
  final String filled;
  final String? selectedEmploymentType;
  final ValueChanged<String> onPositionsChanged;
  final ValueChanged<String> onFilledChanged;
  final ValueChanged<String?> onEmploymentTypeChanged;

  const HeadcountSection({
    super.key,
    required this.localizations,
    required this.positions,
    required this.filled,
    required this.onPositionsChanged,
    required this.onFilledChanged,
    required this.selectedEmploymentType,
    required this.onEmploymentTypeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employmentTypesAsync = ref.watch(employmentTypeLookupValuesProvider);

    return PositionDialogSection(
      title: localizations.headcountInformation,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: "Number of Positions",
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: positions,
                onChanged: onPositionsChanged,
                hint: 'e.g, 5',
              ),
            ),
            PositionLabeledField(
              label: "Filled Positions",
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: filled,
                onChanged: onFilledChanged,
                hint: 'e.g, 3',
              ),
            ),
            employmentTypesAsync.when(
              data: (items) {
                final selected = selectedEmploymentType != null
                    ? items.where((x) => x.lookupCode == selectedEmploymentType).firstOrNull
                    : null;
                return DigifySelectFieldWithLabel<EmplLookupValue>(
                  label: "Employment Type",
                  isRequired: true,
                  value: selected,
                  items: items,
                  onChanged: (v) => onEmploymentTypeChanged(v?.lookupCode),
                  itemLabelBuilder: (v) => v.meaningEn,
                  hint: 'Select Type',
                );
              },
              loading: () => DigifySelectFieldWithLabel<EmplLookupValue>(
                label: "Employment Type",
                isRequired: true,
                value: null,
                items: const [],
                itemLabelBuilder: (_) => '',
                onChanged: null,
                hint: 'Loading Types...',
              ),
              error: (_, _) => DigifySelectFieldWithLabel<EmplLookupValue>(
                label: "Employment Type",
                isRequired: true,
                value: null,
                items: const [],
                itemLabelBuilder: (_) => '',
                onChanged: null,
                hint: 'Error loading',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SalarySection extends ConsumerWidget {
  final AppLocalizations localizations;

  const SalarySection({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grade = ref.watch(positionFormNotifierProvider.select((s) => s.grade));
    final budget = ref.watch(effectiveBudgetForPositionFormProvider);
    final hasGrade = grade != null;

    return PositionDialogSection(
      title: localizations.salaryInformation,
      children: [
        PositionFormRow(
          children: [
            PositionLabeledField(
              label: "${localizations.budgetedMin} (KD)",
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: budget.budgetedMin,
                onChanged: (_) {},
                hint: hasGrade ? null : 'Select grade first',
                readOnly: true,
              ),
            ),
            PositionLabeledField(
              label: "${localizations.budgetedMax} (KD)",
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: budget.budgetedMax,
                onChanged: (_) {},
                hint: hasGrade ? null : 'Select grade first',
                readOnly: true,
              ),
            ),
            PositionLabeledField(
              label: "${localizations.actualAverage} (KD)",
              isRequired: true,
              child: PositionFormHelpers.buildFormFieldFromValue(
                value: budget.actualAverage,
                onChanged: (_) {},
                hint: hasGrade ? null : 'Select grade first',
                readOnly: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ReportingSection extends StatelessWidget {
  final AppLocalizations localizations;
  final int? tenantId;
  final Position? selectedReportsToPosition;
  final ValueChanged<Position?> onReportsToPositionSelected;

  const ReportingSection({
    super.key,
    required this.localizations,
    required this.onReportsToPositionSelected,
    this.tenantId,
    this.selectedReportsToPosition,
  });

  @override
  Widget build(BuildContext context) {
    return PositionDialogSection(
      title: localizations.reportingRelationship,
      children: [
        PositionFormRow(
          children: [
            PositionSearchField(
              label: localizations.reportsTo,
              isRequired: false,
              tenantId: tenantId,
              selectedPosition: selectedReportsToPosition,
              onPositionSelected: onReportsToPositionSelected,
              hintText: 'Type to search positions',
            ),
          ],
        ),
      ],
    );
  }
}
