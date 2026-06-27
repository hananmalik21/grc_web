import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_contract_type_selection_field.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_department_org_fields.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_position_selection_field.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/widgets/create_offer_reporting_to_employee_search_field.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidate_search_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'create_offer_application_fields.dart';
import 'create_offer_section_card.dart';

class CreateOfferBasicDetailsStep extends ConsumerStatefulWidget {
  const CreateOfferBasicDetailsStep({super.key});

  @override
  ConsumerState<CreateOfferBasicDetailsStep> createState() => _CreateOfferBasicDetailsStepState();
}

class _CreateOfferBasicDetailsStepState extends ConsumerState<CreateOfferBasicDetailsStep> {
  late final TextEditingController _gradeLevelController;
  late final TextEditingController _locationController;
  late final TextEditingController _commentsController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createOfferProvider);
    _gradeLevelController = TextEditingController(text: state.gradeLevel);
    _locationController = TextEditingController(text: state.workLocation);
    _commentsController = TextEditingController(text: state.comments);
  }

  @override
  void dispose() {
    _gradeLevelController.dispose();
    _locationController.dispose();
    _commentsController.dispose();
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
    final state = ref.watch(createOfferProvider);
    final notifier = ref.read(createOfferProvider.notifier);

    ref.listen(createOfferProvider.select((s) => s.gradeLevel), (previous, next) {
      final gradeLevel = next ?? '';
      if (_gradeLevelController.text != gradeLevel) {
        _gradeLevelController.text = gradeLevel;
      }
    });

    ref.listen(createOfferProvider.select((s) => s.comments), (previous, next) {
      final comments = next ?? '';
      if (_commentsController.text != comments) {
        _commentsController.text = comments;
      }
    });

    return Column(
      children: [
        CreateOfferSectionCard(
          title: 'Candidate Information',
          child: CandidateSearchField(
            label: 'Candidate',
            isRequired: true,
            selectedCandidate: state.selectedCandidate,
            onCandidateSelected: (candidate) => notifier.updateBasicDetails(selectedCandidate: candidate),
          ),
        ),
        Gap(24.h),
        CreateOfferSectionCard(title: 'Application Information', child: const CreateOfferApplicationFields()),
        Gap(24.h),
        if (state.selectedCandidate == null)
          EmptyStateWidget(
            iconPath: Assets.icons.usersIcon.path,
            title: 'No Candidate Selected',
            message: 'Please select a candidate to view and fill position details',
          )
        else ...[
          CreateOfferSectionCard(
            title: 'Position Details',
            child: Column(
              children: [
                _buildResponsiveRow(
                  context: context,
                  children: [
                    const CreateOfferPositionSelectionField(),
                    DigifyTextField(
                      controller: _gradeLevelController,
                      labelText: 'Grade/Level',
                      isRequired: true,
                      readOnly: true,
                      hintText: 'Select a position to populate grade',
                    ),
                  ],
                ),
                Gap(16.h),
                _buildResponsiveRow(
                  context: context,
                  children: [
                    DigifyTextField(
                      controller: _locationController,
                      labelText: 'Location',
                      isRequired: true,
                      hintText: 'e.g., San Francisco, CA',
                      onChanged: (value) => notifier.updateBasicDetails(workLocation: value),
                    ),
                    DigifySelectFieldWithLabel<String>(
                      label: 'Work Mode',
                      isRequired: true,
                      value: state.workMode,
                      hint: 'Select work mode',
                      items: HiringConfig.workModeOptions,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) => notifier.updateBasicDetails(workMode: value),
                    ),
                  ],
                ),
                Gap(16.h),
                _buildResponsiveRow(
                  context: context,
                  children: [
                    const CreateOfferContractTypeSelectionField(),
                    CreateOfferReportingToEmployeeSearchField(
                      label: l10n.reportingTo,
                      hintText: l10n.hintReportingTo,
                      selectedEmployee: state.selectedReportingTo,
                      onEmployeeSelected: notifier.setReportingTo,
                    ),
                  ],
                ),
                Gap(16.h),
                _buildResponsiveRow(
                  context: context,
                  children: [
                    DigifyDateField(
                      label: 'Proposed Start Date',
                      isRequired: true,
                      hintText: 'dd/mm/yyyy',
                      initialDate: state.proposedStartDate,
                      firstDate: HiringConfig.createRequisitionDatePickerFirstDate,
                      lastDate: HiringConfig.createRequisitionDatePickerLastDate,
                      onDateSelected: (value) => notifier.updateBasicDetails(proposedStartDate: value),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                Gap(16.h),
                DigifyTextArea(
                  controller: _commentsController,
                  labelText: 'Comments',
                  hintText: 'Add any notes or comments about this offer (optional)',
                  maxLines: 4,
                  onChanged: (value) => notifier.updateBasicDetails(comments: value),
                ),
              ],
            ),
          ),
          Gap(context.isMobile ? 20.h : 24.h),
          CreateOfferSectionCard(
            title: l10n.hiringCreateRequisitionOrgStructureCardTitle,
            child: const CreateOfferDepartmentOrgFields(),
          ),
        ],
      ],
    );
  }
}
