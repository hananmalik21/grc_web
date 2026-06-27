import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/common/app_info_tooltip.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'contract_type_selection_field.dart';
import 'create_requisition_department_org_fields.dart';
import 'create_requisition_section_card.dart';
import 'create_requisition_rec_lookup_select_field.dart';
import 'grade_selection_field.dart';
import 'position_selection_field.dart';
import 'job_family_selection_field.dart';
import 'job_level_selection_field.dart';

class CreateRequisitionBasicInfoStep extends ConsumerStatefulWidget {
  const CreateRequisitionBasicInfoStep({super.key});

  @override
  ConsumerState<CreateRequisitionBasicInfoStep> createState() => _CreateRequisitionBasicInfoStepState();
}

class _CreateRequisitionBasicInfoStepState extends ConsumerState<CreateRequisitionBasicInfoStep> {
  late final TextEditingController _openingsController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createRequisitionProvider);
    _openingsController = TextEditingController(text: state.numberOfOpenings.toString());
  }

  @override
  void dispose() {
    _openingsController.dispose();
    super.dispose();
  }

  Widget _buildResponsiveRow({required List<Widget> children, required BuildContext context}) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          final isLast = index == children.length - 1;

          Widget effectiveWidget = widget;
          if (widget is Expanded) {
            effectiveWidget = widget.child;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [effectiveWidget, if (!isLast) Gap(16.h)],
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        final isLast = index == children.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: widget is Expanded ? widget.child : widget),
              if (!isLast) Gap(16.w),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);

    final priorityLookups = ref.watch(createRequisitionPriorityLookupValuesProvider).valueOrNull ?? const [];
    final primaryLocationLookups =
        ref.watch(createRequisitionPrimaryLocationLookupValuesProvider).valueOrNull ?? const [];
    final workModeLookups = ref.watch(createRequisitionWorkModeLookupValuesProvider).valueOrNull ?? const [];

    final positionInfoCard = CreateRequisitionSectionCard(
      title: l10n.hiringCreateRequisitionPositionInformationTitle,
      subtitle: l10n.hiringCreateRequisitionPositionInformationSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CreateRequisitionPositionSelectionField(),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              const CreateRequisitionJobFamilySelectionField(),
              const CreateRequisitionJobLevelSelectionField(),
            ],
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              const CreateRequisitionGradeSelectionField(),
              const CreateRequisitionContractTypeSelectionField(),
            ],
          ),
          Gap(16.h),
          DigifyTextField(
            controller: _openingsController,
            labelText: l10n.hiringCreateRequisitionNumberOfOpenings,
            isRequired: true,
            keyboardType: TextInputType.number,
            onChanged: (value) => notifier.updateBasicInfo(numberOfOpenings: int.tryParse(value) ?? 1),
          ),
          Gap(16.h),
          CreateRequisitionRecLookupSelectField(
            label: l10n.hiringCreateRequisitionPriority,
            isRequired: true,
            selectedKey: state.priority,
            hint: l10n.hiringCreateRequisitionPriorityHint,
            lookups: priorityLookups,
            onChanged: (value) => notifier.updateBasicInfo(priority: value),
          ),
        ],
      ),
    );

    final orgStructureCard = CreateRequisitionSectionCard(
      title: l10n.hiringCreateRequisitionOrgStructureCardTitle,
      subtitle: l10n.hiringCreateRequisitionOrgStructureCardSubtitle,
      child: const CreateRequisitionDepartmentOrgFields(scope: CreateRequisitionOrgSelectionScope.basicInfo),
    );

    final locationArrangementCard = CreateRequisitionSectionCard(
      title: l10n.hiringCreateRequisitionLocationWorkArrangementTitle,
      subtitle: l10n.hiringCreateRequisitionLocationWorkArrangementSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              CreateRequisitionRecLookupSelectField(
                label: l10n.hiringCreateRequisitionPrimaryLocation,
                isRequired: true,
                selectedKey: state.primaryLocation,
                hint: l10n.hiringCreateRequisitionPrimaryLocationHint,
                lookups: primaryLocationLookups,
                matchByGuid: true,
                onChanged: (value) => notifier.updateBasicInfo(primaryLocation: value),
              ),
              CreateRequisitionRecLookupSelectField(
                label: l10n.hiringCreateRequisitionWorkMode,
                isRequired: true,
                selectedKey: state.workMode,
                hint: l10n.hiringCreateRequisitionWorkModeHint,
                lookups: workModeLookups,
                onChanged: (value) => notifier.updateBasicInfo(workMode: value),
              ),
            ],
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              DigifyDateField(
                label: l10n.hiringCreateRequisitionTargetStartDate,
                isRequired: true,
                hintText: l10n.hiringCreateRequisitionDateHint,
                initialDate: state.targetStartDate,
                firstDate: HiringConfig.createRequisitionDatePickerFirstDate,
                lastDate: HiringConfig.createRequisitionDatePickerLastDate,
                onDateSelected: (value) => notifier.updateBasicInfo(targetStartDate: value),
              ),
              DigifyDateField(
                label: l10n.hiringCreateRequisitionExpectedEndDate,
                hintText: state.targetStartDate == null
                    ? 'Select start date first'
                    : l10n.hiringCreateRequisitionDateHint,
                initialDate: state.expectedEndDate,
                firstDate: state.targetStartDate ?? HiringConfig.createRequisitionDatePickerFirstDate,
                lastDate: HiringConfig.createRequisitionDatePickerLastDate,
                readOnly: state.targetStartDate == null,
                suffixIcon: AppInfoTooltip(message: l10n.hiringCreateRequisitionExpectedEndDateTooltip),
                onDateSelected: (value) => notifier.updateBasicInfo(expectedEndDate: value),
              ),
            ],
          ),
        ],
      ),
    );

    if (context.isMobile) {
      return Column(children: [positionInfoCard, Gap(20.h), orgStructureCard, Gap(20.h), locationArrangementCard]);
    }

    return Column(children: [positionInfoCard, Gap(24.h), orgStructureCard, Gap(24.h), locationArrangementCard]);
  }
}
