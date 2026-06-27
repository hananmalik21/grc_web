import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/workforce_structure/presentation/providers/create_grade_form_state_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/grade_structure/create_ent_lookup_value_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class CreateGradeDialog extends ConsumerStatefulWidget {
  const CreateGradeDialog({super.key, this.isSheet = false});
  final bool isSheet;

  static Future<void> show(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: localizations.addGrade,
        barrierDismissible: false,
        child: const CreateGradeDialog(isSheet: true),
      );
    }
    return showDialog<void>(context: context, builder: (_) => const CreateGradeDialog());
  }

  @override
  ConsumerState<CreateGradeDialog> createState() => _CreateGradeDialogState();
}

class _CreateGradeDialogState extends ConsumerState<CreateGradeDialog> {
  late final TextEditingController step1Controller;
  late final TextEditingController step2Controller;
  late final TextEditingController step3Controller;
  late final TextEditingController step4Controller;
  late final TextEditingController step5Controller;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createGradeFormStateProvider);
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
    final success = await ref.read(createGradeFormStateProvider.notifier).submit(context, ref);
    if (mounted && success) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isCreating = ref.watch(gradeCreatingProvider);
    final isMobileForm = widget.isSheet || context.isMobileLayout;

    final formContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildGradeFields(localizations, isMobileForm),
        Gap(24.h),
        _buildStepSalaries(localizations, isMobileForm),
        Gap(24.h),
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
                    onPressed: isCreating ? null : () => context.pop(),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: AppButton.primary(
                    label: localizations.createGrade,
                    onPressed: _handleSave,
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
      title: localizations.addGrade,
      width: 896.w,
      content: formContent,
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: localizations.createGrade,
          svgPath: Assets.icons.saveIcon.path,
          onPressed: _handleSave,
          isLoading: isCreating,
        ),
      ],
    );
  }

  Widget _buildGradeFields(AppLocalizations localizations, bool isMobileForm) {
    if (isMobileForm) {
      return Column(
        children: [_buildGradeCategoryField(localizations), Gap(12.h), _buildGradeNumberField(localizations)],
      );
    }
    return Row(
      children: [
        Expanded(child: _buildGradeCategoryField(localizations)),
        Gap(12.w),
        Expanded(child: _buildGradeNumberField(localizations)),
      ],
    );
  }

  Widget _buildGradeNumberField(AppLocalizations localizations) {
    final gradeNumbersAsync = ref.watch(gradeNumberLookupValuesProvider);
    final isLoading = gradeNumbersAsync.isLoading;
    final items = ref.watch(gradeNumbersForCreateGradeFormProvider);
    final formState = ref.watch(createGradeFormStateProvider);
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);
    final categorySelected = formState.selectedGradeCategory != null;

    String hint;
    if (isLoading) {
      hint = localizations.pleaseWait;
    } else if (!categorySelected) {
      hint = localizations.selectGradeCategoryFirst;
    } else if (items.isEmpty) {
      hint = localizations.noGradeNumbersForCategory;
    } else {
      hint = localizations.selectGrade;
    }

    return _buildLookupSelectField(
      child: DigifySelectFieldWithLabel<EmplLookupValue>(
        label: localizations.gradeNumber,
        hint: hint,
        value: formState.selectedGradeNumber,
        items: items,
        itemLabelBuilder: (v) => v.meaningEn,
        isRequired: true,
        onChanged: (isLoading || !categorySelected || items.isEmpty)
            ? null
            : (v) => formNotifier.setSelectedGradeNumber(v),
      ),
      onAddPressed: () {
        if (!categorySelected) {
          ToastService.warning(context, localizations.selectGradeCategoryFirst);
          return;
        }
        CreateEntLookupValueDialog.show(
          context,
          lookupTypeCode: 'GRADE_NUMBER',
          title: localizations.createNewGradeNumber,
          fieldLabel: localizations.gradeNumber,
        );
      },
    );
  }

  Widget _buildGradeCategoryField(AppLocalizations localizations) {
    final gradeCategoriesAsync = ref.watch(gradeCategoryLookupValuesProvider);
    final items = gradeCategoriesAsync.value ?? [];
    final isLoading = gradeCategoriesAsync.isLoading;
    final formState = ref.watch(createGradeFormStateProvider);
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);

    return _buildLookupSelectField(
      child: DigifySelectFieldWithLabel<EmplLookupValue>(
        label: localizations.gradeCategory,
        hint: isLoading ? localizations.pleaseWait : localizations.selectCategory,
        value: formState.selectedGradeCategory,
        items: items,
        itemLabelBuilder: (v) => '${v.meaningEn} (${v.lookupCode})',
        isRequired: true,
        onChanged: isLoading ? null : (v) => formNotifier.setSelectedGradeCategory(v),
      ),
      onAddPressed: () => CreateEntLookupValueDialog.show(
        context,
        lookupTypeCode: 'GRADE_CATEGORY',
        title: localizations.createNewGradeCategory,
        fieldLabel: localizations.gradeCategory,
      ),
    );
  }

  Widget _buildLookupSelectField({required Widget child, required VoidCallback onAddPressed}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(child: child),
        Gap(12.w),
        AppMobileButton.primary(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onAddPressed),
      ],
    );
  }

  Widget _buildStepSalaries(AppLocalizations localizations, bool isMobileForm) {
    final controllers = [step1Controller, step2Controller, step3Controller, step4Controller, step5Controller];
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);
    final formState = ref.watch(createGradeFormStateProvider);
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
        Text(localizations.stepSalaryStructureTitle, style: context.textTheme.titleSmall?.copyWith(fontSize: 16.0)),
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
    final formNotifier = ref.read(createGradeFormStateProvider.notifier);

    return DigifyTextArea(
      labelText: localizations.descriptionOptional,
      controller: descriptionController,
      hintText: localizations.gradeDescriptionHint,
      maxLines: 3,
      onChanged: formNotifier.setDescription,
    );
  }
}
