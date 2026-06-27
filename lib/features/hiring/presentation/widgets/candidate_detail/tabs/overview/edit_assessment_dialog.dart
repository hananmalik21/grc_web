import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/candidates/controllers/update_candidate_assessment_controller.dart';
import 'package:grc/features/hiring/application/candidates/providers/request_assessment_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/update_candidate_assessment_provider.dart';
import 'package:grc/features/hiring/application/candidates/update_candidate_assessment_args.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_rec_lookup_select_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditAssessmentDialog extends ConsumerWidget {
  const EditAssessmentDialog({super.key, required this.candidate, required this.assessment});

  final CandidateData candidate;
  final CandidateAssessmentData assessment;

  static Future<void> show(
    BuildContext context, {
    required CandidateData candidate,
    required CandidateAssessmentData assessment,
  }) {
    return showDialog(
      context: context,
      builder: (context) => EditAssessmentDialog(candidate: candidate, assessment: assessment),
    );
  }

  UpdateCandidateAssessmentArgs _args() =>
      UpdateCandidateAssessmentArgs(candidateGuid: candidate.id, assessment: assessment);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = _args();
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final formState = ref.watch(updateCandidateAssessmentProvider(args));
    final formNotifier = ref.read(updateCandidateAssessmentProvider(args).notifier);
    final assessmentTypeLookups = ref.watch(requestAssessmentTypeLookupValuesProvider).valueOrNull ?? const [];
    final difficultyLookups = ref.watch(requestAssessmentDifficultyLookupValuesProvider).valueOrNull ?? const [];
    final formKey = formState.assessmentTypeCode ?? 'loading';

    return AppDialog(
      title: l10n.editAssessment,
      width: 650.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  '${l10n.candidate}: ',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
                  ),
                ),
                Text(
                  candidate.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),
          CreateRequisitionRecLookupSelectField(
            label: l10n.assessmentType,
            hint: l10n.technicalCoding,
            isRequired: true,
            selectedKey: formState.assessmentTypeCode,
            lookups: assessmentTypeLookups,
            onChanged: formNotifier.setAssessmentType,
          ),
          Gap(16.h),
          Row(
            children: [
              Expanded(
                child: CreateRequisitionRecLookupSelectField(
                  label: l10n.difficultyLevel,
                  hint: l10n.medium,
                  isRequired: true,
                  selectedKey: formState.difficultyLevelCode,
                  lookups: difficultyLookups,
                  onChanged: formNotifier.setDifficultyLevel,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<int>(
                  label: l10n.durationMinutes,
                  hint: l10n.sixtyMinutes,
                  items: HiringConfig.requestAssessmentDurationMinutes,
                  itemLabelBuilder: HiringConfig.requestAssessmentDurationLabel,
                  value: formState.durationMinutes,
                  onChanged: formNotifier.setDurationMinutes,
                ),
              ),
            ],
          ),
          Gap(16.h),
          DigifyDateField(
            label: l10n.completionDueDate,
            initialDate: formState.dueDate,
            firstDate: HiringConfig.candidateFormDatePickerFirstDate,
            lastDate: HiringConfig.candidateFormDatePickerLastDate,
            onDateSelected: formNotifier.setDueDate,
            hintText: 'dd/mm/yyyy',
          ),
          Gap(16.h),
          _EditAssessmentSkillsSection(notifier: formNotifier, skills: formState.skills),
          Gap(16.h),
          DigifyTextArea(
            key: ValueKey('instructions-$formKey'),
            initialValue: formState.instructions,
            labelText: l10n.instructionsForCandidate,
            hintText: l10n.instructionsHint,
            maxLines: 4,
            onChanged: formNotifier.setInstructions,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: l10n.cancel, onPressed: () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(
          label: l10n.updateAssessment,
          isLoading: formState.isSubmitting,
          onPressed: formState.isSubmitting ? null : () => _onSubmit(context, ref, args, formNotifier),
        ),
      ],
    );
  }

  Future<void> _onSubmit(
    BuildContext context,
    WidgetRef ref,
    UpdateCandidateAssessmentArgs args,
    UpdateCandidateAssessmentNotifier formNotifier,
  ) async {
    final success = await formNotifier.submit();

    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (success) {
      ToastService.success(context, l10n.assessmentUpdatedSuccessfully);
      context.pop();
    } else {
      final state = ref.read(updateCandidateAssessmentProvider(args));
      final message = state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please correct the form errors';
      ToastService.error(context, message);
    }
  }
}

class _EditAssessmentSkillsSection extends StatefulWidget {
  const _EditAssessmentSkillsSection({required this.notifier, required this.skills});

  final UpdateCandidateAssessmentNotifier notifier;
  final List<String> skills;

  @override
  State<_EditAssessmentSkillsSection> createState() => _EditAssessmentSkillsSectionState();
}

class _EditAssessmentSkillsSectionState extends State<_EditAssessmentSkillsSection> {
  final _skillInputController = TextEditingController();

  @override
  void dispose() {
    _skillInputController.dispose();
    super.dispose();
  }

  void _onAddSkill() {
    final added = widget.notifier.addSkill(_skillInputController.text);
    if (added) {
      _skillInputController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.skillsToAssess,
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            AppButton(
              label: l10n.addSkill,
              onPressed: _onAddSkill,
              svgPath: Assets.icons.addDivisionIcon.path,
              backgroundColor: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.infoBg,
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            ),
          ],
        ),
        Gap(8.h),
        DigifyTextField(
          controller: _skillInputController,
          hintText: l10n.skillsHint,
          filled: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _onAddSkill(),
        ),
        if (widget.skills.isNotEmpty) ...[
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: widget.skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundGrey,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      skill,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Gap(8.w),
                    GestureDetector(
                      onTap: () => widget.notifier.removeSkill(skill),
                      child: Icon(
                        Icons.close,
                        size: 14.w,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
