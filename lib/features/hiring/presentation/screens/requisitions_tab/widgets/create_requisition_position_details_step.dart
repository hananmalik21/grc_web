import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_requisition_section_card.dart';
import 'create_requisition_rec_lookup_select_field.dart';

class CreateRequisitionPositionDetailsStep extends ConsumerStatefulWidget {
  const CreateRequisitionPositionDetailsStep({super.key});

  @override
  ConsumerState<CreateRequisitionPositionDetailsStep> createState() => _CreateRequisitionPositionDetailsStepState();
}

class _CreateRequisitionPositionDetailsStepState extends ConsumerState<CreateRequisitionPositionDetailsStep> {
  late final TextEditingController _summaryController;
  late final TextEditingController _responsibilitiesController;
  late final TextEditingController _minQualsController;
  late final TextEditingController _prefQualsController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createRequisitionProvider);
    _summaryController = TextEditingController(text: state.positionSummary);
    _responsibilitiesController = TextEditingController(text: state.keyResponsibilities);
    _minQualsController = TextEditingController(text: state.minimumQualifications);
    _prefQualsController = TextEditingController(text: state.preferredQualifications);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    _responsibilitiesController.dispose();
    _minQualsController.dispose();
    _prefQualsController.dispose();
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
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    final travelLookups = ref.watch(createRequisitionTravelRequirementLookupValuesProvider).valueOrNull ?? const [];
    final certificationsLookups =
        ref.watch(createRequisitionRequiredCertificationsLookupValuesProvider).valueOrNull ?? const [];
    final physicalLookups =
        ref.watch(createRequisitionPhysicalRequirementsLookupValuesProvider).valueOrNull ?? const [];

    final jobDescriptionCard = CreateRequisitionSectionCard(
      title: 'Job Description',
      subtitle: 'Define the core requirements and responsibilities',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextArea(
            controller: _summaryController,
            labelText: 'Position Summary',
            isRequired: true,
            hintText: 'Provide a brief overview of the position...',
            maxLines: 4,
            minLines: 4,
            onChanged: (value) => notifier.updatePositionDetails(positionSummary: value),
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _responsibilitiesController,
            labelText: 'Key Responsibilities',
            isRequired: true,
            hintText: '• Responsibility 1\n• Responsibility 2\n• Responsibility 3...',
            maxLines: 5,
            minLines: 5,
            onChanged: (value) => notifier.updatePositionDetails(keyResponsibilities: value),
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _minQualsController,
            labelText: 'Minimum Qualifications',
            isRequired: true,
            hintText: '• Bachelor\'s degree in...\n• 5+ years of experience in...\n• Proficiency in...',
            maxLines: 4,
            minLines: 4,
            onChanged: (value) => notifier.updatePositionDetails(minimumQualifications: value),
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _prefQualsController,
            labelText: 'Preferred Qualifications',
            hintText: '• Master\'s degree preferred\n• Experience with...',
            maxLines: 4,
            minLines: 4,
            onChanged: (value) => notifier.updatePositionDetails(preferredQualifications: value),
          ),
        ],
      ),
    );

    final additionalReqsCard = CreateRequisitionSectionCard(
      title: 'Additional Requirements',
      subtitle: 'Travel, certifications, and physical demands',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              CreateRequisitionRecLookupSelectField(
                label: 'Travel Requirement',
                selectedKey: state.travelRequirement,
                hint: 'Select travel requirement',
                lookups: travelLookups,
                onChanged: (value) => notifier.updatePositionDetails(travelRequirement: value),
              ),
              CreateRequisitionRecLookupSelectField(
                label: 'Required Certifications',
                selectedKey: state.requiredCertifications,
                hint: 'Select required certifications',
                lookups: certificationsLookups,
                onChanged: (value) => notifier.updatePositionDetails(requiredCertifications: value),
              ),
            ],
          ),
          Gap(16.h),
          CreateRequisitionRecLookupSelectField(
            label: 'Physical Requirements',
            selectedKey: state.physicalRequirements,
            hint: 'Select physical requirements',
            lookups: physicalLookups,
            onChanged: (value) => notifier.updatePositionDetails(physicalRequirements: value),
          ),
        ],
      ),
    );

    if (context.isMobile) {
      return Column(children: [jobDescriptionCard, Gap(20.h), additionalReqsCard]);
    }

    return Column(children: [jobDescriptionCard, Gap(24.h), additionalReqsCard]);
  }
}
