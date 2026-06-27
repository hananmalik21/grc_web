import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/update_grade_form_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class UpdateGradeDialog extends ConsumerStatefulWidget {
  final Grade grade;
  final bool isSheet;

  const UpdateGradeDialog({super.key, required this.grade, this.isSheet = false});

  static Future<void> show(BuildContext context, {required Grade grade}) {
    final localizations = AppLocalizations.of(context)!;
    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: localizations.editGrade,
        barrierDismissible: false,
        child: UpdateGradeDialog(grade: grade, isSheet: true),
      );
    }
    return showDialog<void>(
      context: context,
      builder: (_) => UpdateGradeDialog(grade: grade),
    );
  }

  @override
  ConsumerState<UpdateGradeDialog> createState() => _UpdateGradeDialogState();
}

class _UpdateGradeDialogState extends ConsumerState<UpdateGradeDialog> {
  late final TextEditingController step1Controller;
  late final TextEditingController step2Controller;
  late final TextEditingController step3Controller;
  late final TextEditingController step4Controller;
  late final TextEditingController step5Controller;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final state = UpdateGradeFormState.fromGrade(widget.grade);
    step1Controller = TextEditingController(text: state.step1Salary);
    step2Controller = TextEditingController(text: state.step2Salary);
    step3Controller = TextEditingController(text: state.step3Salary);
    step4Controller = TextEditingController(text: state.step4Salary);
    step5Controller = TextEditingController(text: state.step5Salary);
    descriptionController = TextEditingController(text: state.description);
  }

  @override
  void dispose() {
    step1Controller.dispose();
    step2Controller.dispose();
    step3Controller.dispose();
    step4Controller.dispose();
    step5Controller.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final success = await ref
        .read(updateGradeFormStateProvider(widget.grade).notifier)
        .submit(context, ref, widget.grade);
    if (mounted && success) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final updatingGradeId = ref.watch(gradeNotifierProvider).updatingGradeId;
    final isUpdating = updatingGradeId == widget.grade.id;
    final isMobileForm = widget.isSheet || context.isMobileLayout;

    final formContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGradeInfo(localizations, isMobileForm),
        Gap(16.h),
        _buildStepSalaries(localizations, isMobileForm),
        Gap(18.h),
        _buildDescription(localizations),
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
                    onPressed: isUpdating ? null : () => context.pop(),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: AppButton.primary(
                    label: localizations.saveChanges,
                    onPressed: _handleSave,
                    isLoading: isUpdating,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AppDialog(
      title: localizations.editGrade,
      width: 896.w,
      content: formContent,
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: isUpdating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: localizations.saveChanges,
          svgPath: Assets.icons.saveIcon.path,
          onPressed: _handleSave,
          isLoading: isUpdating,
        ),
      ],
    );
  }

  Widget _buildGradeInfo(AppLocalizations localizations, bool isMobileForm) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20.sp, color: AppColors.textSecondary),
              Gap(8.w),
              Text('(Cannot be changed)', style: context.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
            ],
          ),
          Gap(12.h),
          isMobileForm
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.gradeNumber,
                      style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    Gap(4.h),
                    Text(widget.grade.gradeLabel, style: context.textTheme.titleSmall),
                    Gap(12.h),
                    Text(
                      localizations.gradeCategory,
                      style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
                    ),
                    Gap(4.h),
                    Text(widget.grade.gradeCategoryLabel, style: context.textTheme.titleSmall),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.gradeNumber,
                            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
                          ),
                          Gap(4.h),
                          Text(widget.grade.gradeLabel, style: context.textTheme.titleSmall),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.gradeCategory,
                            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
                          ),
                          Gap(4.h),
                          Text(widget.grade.gradeCategoryLabel, style: context.textTheme.titleSmall),
                        ],
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStepSalaries(AppLocalizations localizations, bool isMobileForm) {
    final controllers = [step1Controller, step2Controller, step3Controller, step4Controller, step5Controller];
    final formNotifier = ref.read(updateGradeFormStateProvider(widget.grade).notifier);
    final formState = ref.watch(updateGradeFormStateProvider(widget.grade));
    final currentSalaries = [
      formState.step1Salary,
      formState.step2Salary,
      formState.step3Salary,
      formState.step4Salary,
      formState.step5Salary,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localizations.stepSalaryStructureTitle, style: context.textTheme.titleMedium),
        Gap(12.h),
        isMobileForm
            ? Column(
                children: controllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final isEnabled = index == 0 || currentSalaries[index - 1].trim().isNotEmpty;
                  return Padding(
                    padding: EdgeInsets.only(bottom: index == controllers.length - 1 ? 0 : 12.h),
                    child: _buildStepInput(
                      localizations,
                      '${localizations.step} ${index + 1}',
                      entry.value,
                      isEnabled,
                      (v) {
                        formNotifier.setStepSalary(index, v);
                        if (v.trim().isEmpty) {
                          for (var i = index + 1; i < controllers.length; i++) {
                            if (controllers[i].text.isNotEmpty) {
                              controllers[i].clear();
                              formNotifier.setStepSalary(i, '');
                            }
                          }
                        }
                      },
                    ),
                  );
                }).toList(),
              )
            : Row(
                children: controllers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final isEnabled = index == 0 || currentSalaries[index - 1].trim().isNotEmpty;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: index == 0 ? 0 : 12.w),
                      child: _buildStepInput(
                        localizations,
                        '${localizations.step} ${index + 1}',
                        entry.value,
                        isEnabled,
                        (v) {
                          formNotifier.setStepSalary(index, v);
                          if (v.trim().isEmpty) {
                            for (var i = index + 1; i < controllers.length; i++) {
                              if (controllers[i].text.isNotEmpty) {
                                controllers[i].clear();
                                formNotifier.setStepSalary(i, '');
                              }
                            }
                          }
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildStepInput(
    AppLocalizations localizations,
    String label,
    TextEditingController controller,
    bool isEnabled,
    ValueChanged<String> onChanged,
  ) {
    return DigifyTextField(
      labelText: label,
      controller: controller,
      hintText: '0.00',
      isRequired: true,
      enabled: isEnabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [AppInputFormatters.decimalWithTwoPlaces()],
      onChanged: onChanged,
      suffixIcon: Center(
        widthFactor: 1.0,
        child: Text(
          localizations.kdSymbol,
          style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildDescription(AppLocalizations localizations) {
    final formNotifier = ref.read(updateGradeFormStateProvider(widget.grade).notifier);

    return DigifyTextArea(
      labelText: localizations.descriptionOptional,
      controller: descriptionController,
      hintText: localizations.gradeDescriptionHint,
      maxLines: 3,
      onChanged: formNotifier.setDescription,
    );
  }
}
