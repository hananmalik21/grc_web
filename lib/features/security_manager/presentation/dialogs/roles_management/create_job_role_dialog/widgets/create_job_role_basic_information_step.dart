import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/data/config/roles_management/job_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateJobRoleBasicInformationStep extends StatelessWidget {
  const CreateJobRoleBasicInformationStep({
    super.key,
    required this.roleNameController,
    required this.roleCodeController,
    required this.jobTitleController,
    required this.descriptionController,
    required this.availableDepartments,
    required this.selectedStatus,
    required this.selectedDepartment,
    required this.onRoleNameChanged,
    required this.onRoleCodeChanged,
    required this.onStatusChanged,
    required this.onJobTitleChanged,
    required this.onDepartmentChanged,
    required this.onDescriptionChanged,
  });

  final TextEditingController roleNameController;
  final TextEditingController roleCodeController;
  final TextEditingController jobTitleController;
  final TextEditingController descriptionController;
  final List<String> availableDepartments;
  final JobRoleStatus selectedStatus;
  final String selectedDepartment;
  final ValueChanged<String> onRoleNameChanged;
  final ValueChanged<String> onRoleCodeChanged;
  final ValueChanged<JobRoleStatus?> onStatusChanged;
  final ValueChanged<String> onJobTitleChanged;
  final ValueChanged<String?> onDepartmentChanged;
  final ValueChanged<String> onDescriptionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField.normal(
          controller: roleNameController,
          labelText: JobRoleFormConfig.roleNameLabel,
          hintText: JobRoleFormConfig.roleNameHint,
          isRequired: true,
          onChanged: onRoleNameChanged,
        ),
        Gap(16.h),
        if (context.isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyTextField.normal(
                controller: roleCodeController,
                labelText: JobRoleFormConfig.roleCodeLabel,
                hintText: JobRoleFormConfig.roleCodeHint,
                isRequired: true,
                onChanged: onRoleCodeChanged,
              ),
              Gap(16.h),
              DigifySelectFieldWithLabel<JobRoleStatus>(
                label: JobRoleFormConfig.statusLabel,
                isRequired: true,
                items: JobRoleFormConfig.statusOptions,
                value: selectedStatus,
                itemLabelBuilder: (item) => item.label,
                onChanged: onStatusChanged,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: DigifyTextField.normal(
                  controller: roleCodeController,
                  labelText: JobRoleFormConfig.roleCodeLabel,
                  hintText: JobRoleFormConfig.roleCodeHint,
                  isRequired: true,
                  onChanged: onRoleCodeChanged,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<JobRoleStatus>(
                  label: JobRoleFormConfig.statusLabel,
                  isRequired: true,
                  items: JobRoleFormConfig.statusOptions,
                  value: selectedStatus,
                  itemLabelBuilder: (item) => item.label,
                  onChanged: onStatusChanged,
                ),
              ),
            ],
          ),
        Gap(16.h),
        DigifyTextField.normal(
          controller: jobTitleController,
          labelText: JobRoleFormConfig.jobTitleLabel,
          hintText: JobRoleFormConfig.jobTitleHint,
          isRequired: true,
          onChanged: onJobTitleChanged,
        ),
        Gap(16.h),
        DigifyTextField(
          labelText: JobRoleFormConfig.descriptionLabel,
          hintText: JobRoleFormConfig.descriptionHint,
          maxLines: 4,
          controller: descriptionController,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
  }
}
