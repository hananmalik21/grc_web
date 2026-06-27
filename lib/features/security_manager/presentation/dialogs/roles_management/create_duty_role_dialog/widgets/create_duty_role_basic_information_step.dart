import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/data/config/roles_management/duty_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDutyRoleBasicInformationStep extends StatelessWidget {
  const CreateDutyRoleBasicInformationStep({
    super.key,
    required this.roleNameController,
    required this.roleCodeController,
    required this.descriptionController,
    required this.categoryLookups,
    required this.categoryLookupsLoading,
    this.categoryLookupsError,
    required this.selectedStatus,
    required this.selectedCategoryCode,
    required this.onRoleNameChanged,
    required this.onRoleCodeChanged,
    required this.onStatusChanged,
    required this.onCategoryCodeChanged,
    required this.onDescriptionChanged,
  });

  final TextEditingController roleNameController;
  final TextEditingController roleCodeController;
  final TextEditingController descriptionController;
  final List<SecurityLookupValue> categoryLookups;
  final bool categoryLookupsLoading;
  final String? categoryLookupsError;
  final String selectedStatus;
  final String selectedCategoryCode;
  final ValueChanged<String> onRoleNameChanged;
  final ValueChanged<String> onRoleCodeChanged;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onCategoryCodeChanged;
  final ValueChanged<String> onDescriptionChanged;

  SecurityLookupValue? get _selectedCategoryLookup {
    for (final v in categoryLookups) {
      if (v.valueCode == selectedCategoryCode) return v;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField.normal(
          controller: roleNameController,
          labelText: DutyRoleFormConfig.roleNameLabel,
          hintText: DutyRoleFormConfig.roleNameHint,
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
                labelText: DutyRoleFormConfig.roleCodeLabel,
                hintText: DutyRoleFormConfig.roleCodeHint,
                isRequired: true,
                onChanged: onRoleCodeChanged,
              ),
              Gap(16.h),
              DigifySelectFieldWithLabel<String>(
                label: DutyRoleFormConfig.statusLabel,
                isRequired: true,
                items: DutyRoleFormConfig.statusOptions,
                value: selectedStatus,
                itemLabelBuilder: (item) => item,
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
                  labelText: DutyRoleFormConfig.roleCodeLabel,
                  hintText: DutyRoleFormConfig.roleCodeHint,
                  isRequired: true,
                  onChanged: onRoleCodeChanged,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifySelectFieldWithLabel<String>(
                  label: DutyRoleFormConfig.statusLabel,
                  isRequired: true,
                  items: DutyRoleFormConfig.statusOptions,
                  value: selectedStatus,
                  itemLabelBuilder: (item) => item,
                  onChanged: onStatusChanged,
                ),
              ),
            ],
          ),
        Gap(16.h),
        DigifySelectFieldWithLabel<SecurityLookupValue>(
          label: DutyRoleFormConfig.categoryLabel,
          isRequired: true,
          items: categoryLookups,
          value: _selectedCategoryLookup,
          itemLabelBuilder: (item) => item.valueName,
          hint: categoryLookupsLoading ? 'Loading categories…' : DutyRoleFormConfig.categoryHint,
          onChanged: categoryLookupsLoading ? null : (v) => onCategoryCodeChanged(v?.valueCode),
        ),
        if (categoryLookupsError != null) ...[
          Gap(6.h),
          Text(
            categoryLookupsError!,
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.error, fontSize: 12.sp),
          ),
        ],
        Gap(16.h),
        DigifyTextArea(
          controller: descriptionController,
          labelText: DutyRoleFormConfig.descriptionLabel,
          hintText: DutyRoleFormConfig.descriptionHint,
          maxLines: 4,
          onChanged: onDescriptionChanged,
        ),
      ],
    );
  }
}
