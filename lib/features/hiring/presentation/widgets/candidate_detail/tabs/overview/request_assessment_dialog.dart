import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/candidates/providers/request_assessment_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/request_assessment_provider.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_rec_lookup_select_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RequestAssessmentDialog extends ConsumerStatefulWidget {
  const RequestAssessmentDialog({super.key, required this.candidate});

  final CandidateData candidate;

  static Future<void> show(BuildContext context, CandidateData candidate) {
    return showDialog(
      context: context,
      builder: (context) => RequestAssessmentDialog(candidate: candidate),
    );
  }

  @override
  ConsumerState<RequestAssessmentDialog> createState() => _RequestAssessmentDialogState();
}

class _RequestAssessmentDialogState extends ConsumerState<RequestAssessmentDialog> {
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _assessmentTemplateController = TextEditingController();

  String get _providerKey => widget.candidate.id;

  @override
  void dispose() {
    ref.read(requestAssessmentProvider(_providerKey).notifier).reset();
    _skillsController.dispose();
    _instructionsController.dispose();
    _assessmentTemplateController.dispose();
    super.dispose();
  }

  void _onAddSkill() {
    final added = ref.read(requestAssessmentProvider(_providerKey).notifier).addSkill(_skillsController.text);
    if (added) {
      _skillsController.clear();
    }
  }

  Future<void> _onSubmit() async {
    final notifier = ref.read(requestAssessmentProvider(_providerKey).notifier);
    notifier.setAssessmentTemplate(_assessmentTemplateController.text);
    notifier.setInstructions(_instructionsController.text);

    final success = await notifier.submit();

    if (!mounted) return;

    if (success) {
      ToastService.success(context, 'Assessment request sent successfully');
      context.pop();
    } else {
      final state = ref.read(requestAssessmentProvider(_providerKey));
      final message = state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please correct the form errors';
      ToastService.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final formState = ref.watch(requestAssessmentProvider(_providerKey));
    final formNotifier = ref.read(requestAssessmentProvider(_providerKey).notifier);
    final assessmentTypeLookups = ref.watch(requestAssessmentTypeLookupValuesProvider).valueOrNull ?? const [];
    final platformLookups = ref.watch(requestAssessmentPlatformLookupValuesProvider).valueOrNull ?? const [];
    final difficultyLookups = ref.watch(requestAssessmentDifficultyLookupValuesProvider).valueOrNull ?? const [];

    return AppDialog(
      title: l10n.requestAssessment,
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
                  widget.candidate.name,
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
          DigifyTextField(
            controller: _assessmentTemplateController,
            labelText: l10n.assessmentTemplate,
            hintText: l10n.selectTemplateOrCustom,
            onChanged: formNotifier.setAssessmentTemplate,
          ),
          Gap(16.h),
          CreateRequisitionRecLookupSelectField(
            label: l10n.platform,
            hint: l10n.internal,
            selectedKey: formState.platformCode,
            lookups: platformLookups,
            onChanged: formNotifier.setPlatform,
          ),
          Gap(16.h),
          Row(
            children: [
              Expanded(
                child: CreateRequisitionRecLookupSelectField(
                  label: l10n.difficultyLevel,
                  hint: l10n.medium,
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
            controller: _skillsController,
            hintText: l10n.skillsHint,
            filled: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _onAddSkill(),
          ),
          if (formState.skills.isNotEmpty) ...[
            Gap(12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: formState.skills.map((skill) {
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
                        onTap: () => formNotifier.removeSkill(skill),
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
          Gap(16.h),
          DigifyTextArea(
            controller: _instructionsController,
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
          label: l10n.sendAssessmentRequest,
          isLoading: formState.isSubmitting,
          onPressed: formState.isSubmitting ? null : _onSubmit,
        ),
      ],
    );
  }
}
