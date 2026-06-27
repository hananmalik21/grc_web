import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/services/toast_service.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../domain/models/grade_structure_management/grade_record.dart';
import '../../providers/grade_structure_management/grade_level_dialog_providor.dart';

class GradeLevelDialog extends ConsumerStatefulWidget {
  const GradeLevelDialog({super.key, this.gradeRecord});

  final GradeRecord? gradeRecord;

  static void show(BuildContext context, {GradeRecord? gradeRecord}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => GradeLevelDialog(),
    );
  }

  @override
  ConsumerState<GradeLevelDialog> createState() => _OvertimeRateDialogState();
}

class _OvertimeRateDialogState extends ConsumerState<GradeLevelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _gradeIdentifierController = TextEditingController();
  final _progressionStepsController = TextEditingController();
  final _institutionalDescriptionController = TextEditingController();
  final _minSalaryController = TextEditingController();
  final _maxSalaryController = TextEditingController();
  final _stepIncrementalGovernanceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.gradeRecord != null) {
      _gradeIdentifierController.text = widget.gradeRecord!.gradeLevel ?? "";
      _progressionStepsController.text = widget.gradeRecord!.steps ?? "";
      _institutionalDescriptionController.text =
          widget.gradeRecord!.description ?? "";
      _minSalaryController.text = widget.gradeRecord!.minSalary ?? "";
      _maxSalaryController.text = widget.gradeRecord!.maxSalary ?? "";
      _stepIncrementalGovernanceController.text =
          widget.gradeRecord!.increment ?? "";

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(gradeLevelDialogProvider.notifier)
            .setInitialData(widget.gradeRecord);
      });
    }
  }

  @override
  void dispose() {
    _gradeIdentifierController.dispose();
    _progressionStepsController.dispose();
    _institutionalDescriptionController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _stepIncrementalGovernanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      gradeLevelDialogProvider.select((state) => state.isLoading),
    );
    final notifier = ref.read(gradeLevelDialogProvider.notifier);
    return AppDialog(
      title: widget.gradeRecord != null
          ? 'Modify Grade Level'
          : 'Initiate New Grade Level',
      width: 450.w,

      onClose: () => context.pop(),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (context.isMobile) ...[
              DigifyTextField.number(
                controller: _gradeIdentifierController,
                labelText: 'Grade Identifier',
                onChanged: (value) => notifier.updateGradeIdentifier(value),
                hintText: 'e.g. 1, 2 etc.',
              ),
              Gap(16.h),
              DigifyTextField.number(
                controller: _progressionStepsController,
                labelText: 'Progression Steps',
                onChanged: (value) => notifier.updateProgressionSteps(value),
                hintText: 'e.g. Special Project Rate',
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: DigifyTextField.number(
                      controller: _gradeIdentifierController,
                      labelText: 'Grade Identifier',
                      onChanged: (value) =>
                          notifier.updateGradeIdentifier(value),
                      hintText: 'e.g. 1, 2 etc.',
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifyTextField.number(
                      controller: _progressionStepsController,
                      labelText: 'Progression Steps',
                      onChanged: (value) =>
                          notifier.updateProgressionSteps(value),
                      hintText: 'e.g. Special Project Rate',
                    ),
                  ),
                ],
              ),
            ],
            Gap(16.h),
            DigifyTextArea(
              controller: _institutionalDescriptionController,
              onChanged: (value) =>
                  notifier.updateInstitutionalDescription(value),
              labelText: 'Institutional Description',
              hintText: 'Describe when this rate applies...',
            ),
            Gap(16.h),
            if (context.isMobile) ...[
              DigifyTextField.number(
                controller: _minSalaryController,
                labelText: 'Min Salary (KWD)',
                onChanged: (value) => notifier.updateMinSalary(value),
                hintText: 'e.g. 100, 250 etc.',
              ),
              Gap(16.h),
              DigifyTextField.number(
                controller: _maxSalaryController,
                labelText: 'Max Salary (KWD)',
                onChanged: (value) => notifier.updateMaxSalary(value),
                hintText: 'e.g. 100, 250 etc.',
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: DigifyTextField.number(
                      controller: _minSalaryController,
                      labelText: 'Min Salary (KWD)',
                      onChanged: (value) => notifier.updateMinSalary(value),
                      hintText: 'e.g. 100, 250 etc.',
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifyTextField.number(
                      controller: _maxSalaryController,
                      labelText: 'Max Salary (KWD)',
                      onChanged: (value) => notifier.updateMaxSalary(value),
                      hintText: 'e.g. 100, 250 etc.',
                    ),
                  ),
                ],
              ),
            ],
            Gap(16.h),
            DigifyTextField.number(
              controller: _stepIncrementalGovernanceController,
              onChanged: (value) =>
                  notifier.updateStepIncrementalGovernance(value),
              labelText: 'Step Incremental Governance',
              hintText: 'e.g. 10, 30 etc.',
            ),
            Gap(24.h),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          onPressed: () => context.pop(),

          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textSecondary,
        ),
        Gap(12.w),
        AppButton(
          label: 'Commit Protocol',
          isLoading: isLoading,
          onPressed: () => _handleSubmit(ref),
          svgPath: Assets.icons.saveConfigIcon.path,
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  Future<void> _handleSubmit(WidgetRef ref) async {
    final notifier = ref.read(gradeLevelDialogProvider.notifier);

    try {
      await notifier.handleSubmit(ref);
      if (!mounted) return;
      ToastService.success(
        context,
        'Grade Level ${widget.gradeRecord != null ? 'updated' : 'saved'} successfully.',
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ToastService.error(
        context,
        'Failed to ${widget.gradeRecord != null ? 'update' : 'save'} grade level. Please try again.',
      );
    }
  }
}
