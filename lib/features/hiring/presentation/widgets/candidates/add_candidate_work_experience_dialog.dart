import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_work_experience_input.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddCandidateWorkExperienceDialog extends StatefulWidget {
  const AddCandidateWorkExperienceDialog({super.key, this.initialEntry});

  final CreateCandidateWorkExperienceInput? initialEntry;

  static Future<CreateCandidateWorkExperienceInput?> show(
    BuildContext context, {
    CreateCandidateWorkExperienceInput? initialEntry,
  }) {
    return showDialog<CreateCandidateWorkExperienceInput>(
      context: context,
      builder: (context) => AddCandidateWorkExperienceDialog(initialEntry: initialEntry),
    );
  }

  @override
  State<AddCandidateWorkExperienceDialog> createState() => _AddCandidateWorkExperienceDialogState();
}

class _AddCandidateWorkExperienceDialogState extends State<AddCandidateWorkExperienceDialog> {
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _isCurrentJobLabel = 'No';

  bool get _isEditing => widget.initialEntry != null;
  bool get _isCurrentJob => _isCurrentJobLabel == 'Yes';

  @override
  void initState() {
    super.initState();
    final entry = widget.initialEntry;
    if (entry != null) {
      _companyController.text = entry.companyName;
      _jobTitleController.text = entry.jobTitle;
      _locationController.text = entry.location;
      _descriptionController.text = entry.description;
      _startDate = entry.startDate;
      _endDate = entry.endDate;
      _isCurrentJobLabel = entry.isCurrentJob ? 'Yes' : 'No';
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _jobTitleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (_companyController.text.trim().isEmpty) {
      ToastService.error(context, 'Company name is required');
      return;
    }
    if (_jobTitleController.text.trim().isEmpty) {
      ToastService.error(context, 'Job title is required');
      return;
    }
    if (_locationController.text.trim().isEmpty) {
      ToastService.error(context, 'Location is required');
      return;
    }
    if (_startDate == null) {
      ToastService.error(context, 'Start date is required');
      return;
    }
    final entry = CreateCandidateWorkExperienceInput(
      id: widget.initialEntry?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      companyName: _companyController.text.trim(),
      jobTitle: _jobTitleController.text.trim(),
      location: _locationController.text.trim(),
      startDate: _startDate!,
      endDate: _isCurrentJob ? null : _endDate,
      isCurrentJob: _isCurrentJob,
      description: _descriptionController.text.trim(),
    );
    context.pop(entry);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fillColor = isDark ? AppColors.inputBgDark : Colors.white;

    return AppDialog(
      title: _isEditing ? 'Edit Work Experience' : 'Add Work Experience',
      width: 520.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DigifyTextField(
            labelText: 'Company Name',
            isRequired: true,
            controller: _companyController,
            hintText: 'e.g. Digify HR',
            fillColor: fillColor,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: 'Job Title',
            isRequired: true,
            controller: _jobTitleController,
            hintText: 'e.g. Business Applications Manager',
            fillColor: fillColor,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: 'Location',
            isRequired: true,
            controller: _locationController,
            hintText: 'e.g. Kuwait',
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
          DigifySelectFieldWithLabel<String>(
            label: 'Current Job',
            isRequired: true,
            value: _isCurrentJobLabel,
            items: HiringConfig.currentJobOptions,
            itemLabelBuilder: (item) => item,
            hint: 'Select',
            fillColor: fillColor,
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _isCurrentJobLabel = value;
                if (_isCurrentJob) _endDate = null;
              });
            },
          ),
          if (!_isCurrentJob) ...[
            Gap(16.h),
            DigifyDateField(
              label: 'End Date',
              isRequired: false,
              hintText: 'dd/mm/yyyy',
              initialDate: _endDate,
              firstDate: HiringConfig.candidateFormDatePickerFirstDate,
              lastDate: HiringConfig.candidateFormDatePickerLastDate,
              fillColor: fillColor,
              onDateSelected: (date) => setState(() => _endDate = date),
            ),
          ],
          Gap(16.h),
          DigifyTextArea(
            labelText: 'Description',
            hintText: 'e.g. Managing enterprise applications',
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
          label: _isEditing ? 'Save Changes' : 'Add Experience',
          svgPath: Assets.icons.saveDivisionIcon.path,
          onPressed: _save,
        ),
      ],
    );
  }
}
