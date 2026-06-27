import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/workforce_structure/domain/models/grade_step.dart';
import 'package:grc/features/workforce_structure/domain/models/grade_structure.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';

class GradeFormDialog extends StatefulWidget {
  final GradeStructure? grade;
  final ValueChanged<GradeStructure>? onSave;
  final bool isEdit;

  const GradeFormDialog({super.key, this.grade, this.onSave, this.isEdit = false});

  static Future<void> show(
    BuildContext context, {
    GradeStructure? grade,
    ValueChanged<GradeStructure>? onSave,
    bool isEdit = false,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => GradeFormDialog(grade: grade, onSave: onSave, isEdit: isEdit),
    );
  }

  @override
  State<GradeFormDialog> createState() => _GradeFormDialogState();
}

class _GradeFormDialogState extends State<GradeFormDialog> {
  late final TextEditingController descriptionController;
  late final TextEditingController gradeNumberController;
  late final TextEditingController gradeCategoryController;
  final List<TextEditingController> _stepControllers = [];
  final _formKey = GlobalKey<FormState>();
  static const _stepCount = 5;

  @override
  void initState() {
    super.initState();
    final grade = widget.grade;
    descriptionController = TextEditingController(text: grade?.description ?? '');
    gradeNumberController = TextEditingController(text: grade?.gradeLabel ?? '');
    gradeCategoryController = TextEditingController(text: grade?.gradeCategory ?? '');
    final steps = grade?.steps ?? [];
    for (var index = 0; index < _stepCount; index++) {
      final step = index < steps.length ? steps[index] : null;
      _stepControllers.add(TextEditingController(text: step?.amount ?? ''));
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    gradeNumberController.dispose();
    gradeCategoryController.dispose();
    for (final controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 896.w, maxWidth: 896.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 26.h),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.isEdit ? localizations.editGrade : localizations.addGrade,
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints.tight(Size(32.w, 32.h)),
                        icon: Icon(Icons.close_rounded, size: 20.sp, color: AppColors.textSecondary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: localizations.gradeNumber,
                          hint: localizations.selectGrade,
                          controller: gradeNumberController,
                          suffixIcon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildField(
                          label: localizations.gradeCategory,
                          hint: localizations.entryLevel,
                          controller: gradeCategoryController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      localizations.stepSalaryStructureTitle,
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _stepControllers.asMap().entries.map((entry) {
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: entry.key == 0 ? 0 : 12.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${localizations.step} ${entry.key + 1}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              _buildStepInput(entry.value),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 18.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      localizations.descriptionOptional,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildField(
                    label: localizations.descriptionOptional,
                    hint: localizations.gradeDescriptionHint,
                    controller: descriptionController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton.outline(
                          label: localizations.cancel,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton.primary(
                          label: widget.isEdit ? localizations.saveChanges : localizations.createGrade,
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final steps = _stepControllers
                                  .asMap()
                                  .entries
                                  .map(
                                    (entry) => GradeStep(
                                      label: '${localizations.step} ${entry.key + 1}',
                                      amount: entry.value.text,
                                    ),
                                  )
                                  .where((step) => step.amount.isNotEmpty)
                                  .toList();
                              final grade = GradeStructure(
                                gradeLabel: gradeNumberController.text,
                                gradeCategory: gradeCategoryController.text,
                                description: descriptionController.text,
                                steps: steps,
                              );
                              widget.onSave?.call(grade);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
        SizedBox(height: 4.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            fillColor: AppColors.inputBg,
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
            suffixIcon: suffixIcon,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
          ),
          validator: (value) {
            if ((value ?? '').isEmpty) {
              return '';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStepInput(TextEditingController controller) {
    final localizations = AppLocalizations.of(context)!;
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: localizations.gradeStepAmountHint,
        hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        suffixText: localizations.kdSymbol,
        suffixStyle: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        fillColor: AppColors.inputBg,
        filled: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
      ),
      validator: (value) {
        if ((value ?? '').isEmpty) {
          return '';
        }
        return null;
      },
    );
  }
}
