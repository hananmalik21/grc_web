import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_shared_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleBasicInformationStep extends StatelessWidget {
  const CreateDataRoleBasicInformationStep({
    super.key,
    required this.roleNameController,
    required this.roleCodeController,
    required this.descriptionController,
    required this.dataTypeOptions,
    required this.dataTypeOptionsLoading,
    this.dataTypeOptionsError,
    required this.selectedDataType,
    required this.selectedStatus,
    required this.onRoleNameChanged,
    required this.onRoleCodeChanged,
    required this.onDescriptionChanged,
    required this.onDataTypeChanged,
    required this.onStatusChanged,
  });

  final TextEditingController roleNameController;
  final TextEditingController roleCodeController;
  final TextEditingController descriptionController;
  final List<String> dataTypeOptions;
  final bool dataTypeOptionsLoading;
  final String? dataTypeOptionsError;
  final String? selectedDataType;
  final DataRoleStatus selectedStatus;
  final ValueChanged<String> onRoleNameChanged;
  final ValueChanged<String> onRoleCodeChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String?> onDataTypeChanged;
  final ValueChanged<DataRoleStatus?> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateDataRoleStepHeader(title: DataRoleFormConfig.stepLabels[0]),
        Gap(18.h),
        if (context.isMobile) ...[
          DigifyTextField(
            controller: roleNameController,
            labelText: DataRoleFormConfig.roleNameLabel,
            hintText: DataRoleFormConfig.roleNameHint,
            isRequired: true,
            onChanged: onRoleNameChanged,
          ),
          Gap(18.h),
          DigifyTextField(
            controller: roleCodeController,
            labelText: DataRoleFormConfig.roleCodeLabel,
            hintText: DataRoleFormConfig.roleCodeHint,
            isRequired: true,
            onChanged: onRoleCodeChanged,
          ),
          Gap(18.h),
          DigifySelectFieldWithLabel<String>(
            label: DataRoleFormConfig.dataTypeLabel,
            items: dataTypeOptions,
            value: selectedDataType,
            itemLabelBuilder: (item) => item,
            hint: dataTypeOptionsLoading ? 'Loading data types...' : null,
            isRequired: true,
            onChanged: dataTypeOptionsLoading ? null : onDataTypeChanged,
          ),
          if (dataTypeOptionsError != null) ...[
            Gap(6.h),
            Text(
              dataTypeOptionsError!,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 12.sp),
            ),
          ],
          Gap(18.h),
          DigifySelectFieldWithLabel<DataRoleStatus>(
            label: DataRoleFormConfig.statusLabel,
            items: DataRoleFormConfig.statusOptions,
            value: selectedStatus,
            itemLabelBuilder: (item) => item.label,
            onChanged: onStatusChanged,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: roleNameController,
                  labelText: DataRoleFormConfig.roleNameLabel,
                  hintText: DataRoleFormConfig.roleNameHint,
                  isRequired: true,
                  onChanged: onRoleNameChanged,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  controller: roleCodeController,
                  labelText: DataRoleFormConfig.roleCodeLabel,
                  hintText: DataRoleFormConfig.roleCodeHint,
                  isRequired: true,
                  onChanged: onRoleCodeChanged,
                ),
              ),
            ],
          ),
          Gap(18.h),
          Row(
            children: [
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: DataRoleFormConfig.dataTypeLabel,
                  items: dataTypeOptions,
                  value: selectedDataType,
                  itemLabelBuilder: (item) => item,
                  hint: dataTypeOptionsLoading ? 'Loading data types...' : null,
                  isRequired: true,
                  onChanged: dataTypeOptionsLoading ? null : onDataTypeChanged,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<DataRoleStatus>(
                  label: DataRoleFormConfig.statusLabel,
                  items: DataRoleFormConfig.statusOptions,
                  value: selectedStatus,
                  itemLabelBuilder: (item) => item.label,
                  onChanged: onStatusChanged,
                ),
              ),
            ],
          ),
          if (dataTypeOptionsError != null) ...[
            Gap(6.h),
            Text(
              dataTypeOptionsError!,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 12.sp),
            ),
          ],
        ],
        Gap(18.h),
        DigifyTextArea(
          controller: descriptionController,
          labelText: DataRoleFormConfig.descriptionLabel,
          hintText: DataRoleFormConfig.descriptionHint,
          isRequired: false,
          maxLines: 4,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
  }
}
