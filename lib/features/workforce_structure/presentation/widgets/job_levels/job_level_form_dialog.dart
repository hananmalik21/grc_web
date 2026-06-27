import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_form_state_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobLevelFormDialog extends ConsumerStatefulWidget {
  final JobLevel? jobLevel;
  final ValueChanged<JobLevel>? onSave;
  final bool isEdit;
  final bool isSheet;

  const JobLevelFormDialog({super.key, this.jobLevel, this.onSave, this.isEdit = false, this.isSheet = false});

  static Future<void> show(
    BuildContext context, {
    JobLevel? jobLevel,
    ValueChanged<JobLevel>? onSave,
    bool isEdit = false,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final title = isEdit ? localizations.editJobLevel : localizations.addNewJobLevel;

    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: JobLevelFormDialog(jobLevel: jobLevel, onSave: onSave, isEdit: isEdit, isSheet: true),
      );
    }

    return showDialog<void>(
      context: context,
      builder: (_) => JobLevelFormDialog(jobLevel: jobLevel, onSave: onSave, isEdit: isEdit),
    );
  }

  @override
  ConsumerState<JobLevelFormDialog> createState() => _JobLevelFormDialogState();
}

class _JobLevelFormDialogState extends ConsumerState<JobLevelFormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController codeController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final level = widget.jobLevel;
    nameController = TextEditingController(text: level?.nameEn ?? '');
    codeController = TextEditingController(text: level?.code ?? '');
    descriptionController = TextEditingController(text: level?.description ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final result = await ref
        .read(jobLevelFormStateProvider(widget.jobLevel).notifier)
        .submitJobLevel(
          context,
          ref,
          nameEn: nameController.text,
          code: codeController.text,
          description: descriptionController.text,
          isEdit: widget.isEdit,
          existingJobLevel: widget.jobLevel,
        );
    if (!mounted) return;
    switch (result) {
      case JobLevelSubmitSuccess(:final level, :final successMessage):
        ToastService.success(context, successMessage);
        widget.onSave?.call(level);
        context.pop();
      case JobLevelSubmitApiError(:final errorMessage):
        ToastService.error(context, errorMessage);
      case JobLevelSubmitValidationFailure():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isEdit = widget.isEdit;
    final isCreating = ref.watch(jobLevelCreatingProvider);
    final isMobileForm = widget.isSheet || context.isMobileLayout;
    final gradeFields = Builder(
      builder: (context) {
        final gradesAsync = ref.watch(gradesForJobLevelFormProvider);
        final grades = gradesAsync.valueOrNull ?? [];
        final gradesLoading = gradesAsync.isLoading;
        final formState = ref.watch(jobLevelFormStateProvider(widget.jobLevel));
        final formNotifier = ref.read(jobLevelFormStateProvider(widget.jobLevel).notifier);
        final maxGradeOptions = ref.watch(maxGradeOptionsForJobLevelFormProvider(widget.jobLevel));

        final minField = DigifySelectFieldWithLabel<Grade>(
          label: localizations.minimumGrade,
          hint: gradesLoading ? localizations.pleaseWait : localizations.selectGrade,
          items: grades,
          itemLabelBuilder: (g) => g.gradeLabel,
          value: formState.selectedMinGrade,
          onChanged: gradesLoading ? null : (v) => formNotifier.setMinGrade(v),
          isRequired: true,
        );

        final maxField = DigifySelectFieldWithLabel<Grade>(
          label: localizations.maximumGrade,
          hint: gradesLoading
              ? localizations.pleaseWait
              : (formState.selectedMinGrade == null
                    ? localizations.selectMinimumGradeFirst
                    : maxGradeOptions.isEmpty
                    ? localizations.noHigherGradesAvailable
                    : localizations.selectGrade),
          items: maxGradeOptions,
          itemLabelBuilder: (g) => g.gradeLabel,
          value:
              formState.selectedMaxGrade != null && maxGradeOptions.any((g) => g.id == formState.selectedMaxGrade!.id)
              ? formState.selectedMaxGrade
              : null,
          onChanged: (gradesLoading || formState.selectedMinGrade == null || maxGradeOptions.isEmpty)
              ? null
              : (v) => formNotifier.setMaxGrade(v),
          isRequired: true,
        );

        if (isMobileForm) {
          return Column(children: [minField, Gap(12.h), maxField]);
        }

        return Row(
          children: [
            Expanded(child: minField),
            Gap(12.w),
            Expanded(child: maxField),
          ],
        );
      },
    );

    final formContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.basicInformation,
          style: context.textTheme.headlineSmall?.copyWith(color: AppColors.textPrimary),
        ),
        Gap(20.h),
        DigifyTextField(
          labelText: localizations.levelName,
          hintText: localizations.levelNameHint,
          controller: nameController,
          readOnly: isEdit,
          isRequired: true,
        ),
        Gap(12.h),
        DigifyTextField(
          labelText: localizations.jobLevelCode,
          hintText: localizations.jobLevelCodeHint,
          controller: codeController,
          readOnly: isEdit,
          isRequired: true,
        ),
        Gap(12.h),
        DigifyTextArea(
          labelText: localizations.description,
          hintText: localizations.jobLevelDescriptionHint,
          controller: descriptionController,
          maxLines: 3,
          isRequired: true,
        ),
        Gap(12.h),
        gradeFields,
      ],
    );

    if (widget.isSheet) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
              child: formContent,
            ),
          ),
          const DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: localizations.cancel,
                    onPressed: isCreating ? null : () => context.pop(),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: AppButton.primary(
                    label: isEdit ? localizations.saveChanges : localizations.createJobLevel,
                    onPressed: isCreating ? null : _handleSave,
                    isLoading: isCreating,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AppDialog(
      title: isEdit ? localizations.editJobLevel : localizations.addNewJobLevel,
      width: 896.w,
      content: formContent,
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: isEdit ? localizations.saveChanges : localizations.createJobLevel,
          onPressed: isCreating ? null : _handleSave,
          isLoading: isCreating,
        ),
      ],
    );
  }
}
