import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_education_input.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddCandidateEducationDialog extends StatefulWidget {
  const AddCandidateEducationDialog({super.key, this.initialEntry});

  final CreateCandidateEducationInput? initialEntry;

  static Future<CreateCandidateEducationInput?> show(
    BuildContext context, {
    CreateCandidateEducationInput? initialEntry,
  }) {
    return showDialog<CreateCandidateEducationInput>(
      context: context,
      builder: (context) => AddCandidateEducationDialog(initialEntry: initialEntry),
    );
  }

  @override
  State<AddCandidateEducationDialog> createState() => _AddCandidateEducationDialogState();
}

class _AddCandidateEducationDialogState extends State<AddCandidateEducationDialog> {
  final _degreeController = TextEditingController();
  final _institutionController = TextEditingController();
  final _fieldOfStudyController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String? _grade;

  bool get _isEditing => widget.initialEntry != null;

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    if (entry != null) {
      _degreeController.text = entry.degreeName;
      _institutionController.text = entry.institutionName;
      _fieldOfStudyController.text = entry.fieldOfStudy;
      _descriptionController.text = entry.description;
      _startDate = entry.startDate;
      _endDate = entry.endDate;
      _grade = entry.grade;
    }
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _fieldOfStudyController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_degreeController.text.trim().isEmpty) {
      ToastService.error(context, 'Degree name is required');
      return;
    }
    if (_institutionController.text.trim().isEmpty) {
      ToastService.error(context, 'Institution name is required');
      return;
    }
    if (_fieldOfStudyController.text.trim().isEmpty) {
      ToastService.error(context, 'Field of study is required');
      return;
    }
    if (_startDate == null) {
      ToastService.error(context, 'Start date is required');
      return;
    }
    if (_endDate == null) {
      ToastService.error(context, 'End date is required');
      return;
    }
    if (_grade == null || _grade!.isEmpty) {
      ToastService.error(context, 'Grade is required');
      return;
    }

    final entry = CreateCandidateEducationInput(
      id: widget.initialEntry?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      degreeName: _degreeController.text.trim(),
      institutionName: _institutionController.text.trim(),
      fieldOfStudy: _fieldOfStudyController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      grade: _grade!,
      description: _descriptionController.text.trim(),
    );
    context.pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fillColor = isDark ? AppColors.inputBgDark : Colors.white;

    return AppDialog(
      title: _isEditing ? 'Edit Education' : 'Add Education',
      width: 520.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DigifyTextField(
            labelText: 'Degree Name',
            isRequired: true,
            controller: _degreeController,
            hintText: 'e.g. MBA',
            fillColor: fillColor,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: 'Institution Name',
            isRequired: true,
            controller: _institutionController,
            hintText: 'e.g. Hult International Business School',
            fillColor: fillColor,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: 'Field of Study',
            isRequired: true,
            controller: _fieldOfStudyController,
            hintText: 'e.g. Business Administration',
            fillColor: fillColor,
          ),
          Gap(16.h),
          DigifyDateField(
            label: 'Start Date',
            isRequired: true,
            hintText: 'dd/mm/yyyy',
            initialDate: _startDate,
            firstDate: HiringConfig.candidateFormDatePickerFirstDate,
            lastDate: HiringConfig.candidateFormDatePickerLastDate,
            fillColor: fillColor,
            onDateSelected: (date) => setState(() => _startDate = date),
          ),
          Gap(16.h),
          DigifyDateField(
            label: 'End Date',
            isRequired: true,
            hintText: 'dd/mm/yyyy',
            initialDate: _endDate,
            firstDate: HiringConfig.candidateFormDatePickerFirstDate,
            lastDate: HiringConfig.candidateFormDatePickerLastDate,
            fillColor: fillColor,
            onDateSelected: (date) => setState(() => _endDate = date),
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Grade',
            isRequired: true,
            value: _grade,
            items: HiringConfig.educationGradeOptions,
            itemLabelBuilder: (item) => item,
            hint: 'Select grade',
            fillColor: fillColor,
            onChanged: (value) => setState(() => _grade = value),
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: 'Description',
            hintText: 'e.g. Master Degree',
            controller: _descriptionController,
            maxLines: 3,
            fillColor: fillColor,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(
          label: _isEditing ? 'Save Changes' : 'Add Education',
          svgPath: Assets.icons.saveDivisionIcon.path,
          onPressed: _save,
        ),
      ],
    );
  }
}
