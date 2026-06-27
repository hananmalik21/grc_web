import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/position_search_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_requisition_department_org_fields.dart';
import 'create_requisition_section_card.dart';
import 'create_requisition_rec_lookup_select_field.dart';

class CreateRequisitionJustificationStep extends ConsumerStatefulWidget {
  const CreateRequisitionJustificationStep({super.key});

  @override
  ConsumerState<CreateRequisitionJustificationStep> createState() => _CreateRequisitionJustificationStepState();
}

class _CreateRequisitionJustificationStepState extends ConsumerState<CreateRequisitionJustificationStep> {
  late final TextEditingController _businessJustificationController;
  late final TextEditingController _impactController;
  late final TextEditingController _costCenterController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createRequisitionProvider);
    _businessJustificationController = TextEditingController(text: state.businessJustification);
    _impactController = TextEditingController(text: state.impactIfNotFilled);
    _costCenterController = TextEditingController(text: state.costCenter);
  }

  @override
  void dispose() {
    _businessJustificationController.dispose();
    _impactController.dispose();
    _costCenterController.dispose();
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
    final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
    final positionTypeLookups = ref.watch(createRequisitionPositionTypeLookupValuesProvider).valueOrNull ?? const [];

    final positionJustificationCard = CreateRequisitionSectionCard(
      title: 'Position Justification',
      subtitle: 'Provide the reasoning for this position',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CreateRequisitionRecLookupSelectField(
            label: 'Position Type',
            isRequired: true,
            selectedKey: state.positionType,
            hint: 'Select position type',
            lookups: positionTypeLookups,
            onChanged: (value) => notifier.updateJustification(positionType: value),
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _businessJustificationController,
            labelText: 'Business Justification',
            isRequired: true,
            hintText: 'Explain why this position is needed and how it aligns with business objectives...',
            maxLines: 5,
            minLines: 5,
            onChanged: (value) => notifier.updateJustification(businessJustification: value),
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _impactController,
            labelText: 'Impact if Not Filled',
            isRequired: true,
            hintText: 'Describe the business impact if this position remains unfilled...',
            maxLines: 4,
            minLines: 4,
            onChanged: (value) => notifier.updateJustification(impactIfNotFilled: value),
          ),
        ],
      ),
    );

    final orgUnitCard = CreateRequisitionSectionCard(
      title: l10n.hiringCreateRequisitionOrgStructureCardTitle,
      subtitle: l10n.hiringCreateRequisitionOrgStructureCardSubtitle,
      child: const CreateRequisitionDepartmentOrgFields(scope: CreateRequisitionOrgSelectionScope.justification),
    );

    final orgStructureCard = CreateRequisitionSectionCard(
      title: 'Organizational Structure',
      subtitle: 'Define where this position sits in the organization',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              PositionSearchField(
                label: 'Reports To',
                isRequired: true,
                tenantId: tenantId,
                selectedPosition: state.reportsToPosition,
                hintText: 'Type to search positions',
                onPositionSelected: (position) {
                  if (position == null) return;
                  notifier.updateJustification(reportsToPosition: position);
                },
              ),
              DigifyTextField(
                controller: _costCenterController,
                labelText: 'Cost Center',
                isRequired: true,
                hintText: 'e.g., CC-1234',
                onChanged: (value) => notifier.updateJustification(costCenter: value),
              ),
            ],
          ),
        ],
      ),
    );

    if (context.isMobile) {
      return Column(children: [positionJustificationCard, Gap(20.h), orgUnitCard, Gap(20.h), orgStructureCard]);
    }

    return Column(children: [positionJustificationCard, Gap(24.h), orgUnitCard, Gap(24.h), orgStructureCard]);
  }
}
