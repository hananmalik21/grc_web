import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/enums/active_inactive_status.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/module_field.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RoleDetailsStep extends StatelessWidget {
  const RoleDetailsStep({
    super.key,
    required this.nameController,
    required this.codeController,
    required this.descriptionController,
    required this.state,
    required this.notifier,
    required this.moduleNames,
    required this.formModule,
    required this.modulesLoading,
    required this.modulesError,
  });

  final TextEditingController nameController;
  final TextEditingController codeController;
  final TextEditingController descriptionController;
  final FunctionRolesState state;
  final FunctionRolesNotifier notifier;
  final List<String> moduleNames;
  final String? formModule;
  final bool modulesLoading;
  final String? modulesError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField(
          controller: nameController,
          labelText: 'Role Name',
          hintText: 'Enter function role name',
          isRequired: true,
        ),
        Gap(18.h),
        if (context.isMobile) ...[
          DigifyTextField(
            controller: codeController,
            labelText: 'Role Code',
            hintText: 'Enter role code',
            isRequired: true,
          ),
          Gap(18.h),
          FunctionRoleModuleField(
            moduleNames: moduleNames,
            formModule: formModule,
            modulesLoading: modulesLoading,
            modulesError: modulesError,
            onModuleChanged: notifier.updateFormModule,
          ),
          Gap(18.h),
          DigifySelectFieldWithLabel<ActiveInactiveStatus>(
            label: 'Status',
            isRequired: true,
            items: ActiveInactiveStatus.values,
            value: state.formStatus,
            itemLabelBuilder: (item) => item.label,
            onChanged: notifier.updateFormStatus,
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: codeController,
                  labelText: 'Role Code',
                  hintText: 'Enter role code',
                  isRequired: true,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: FunctionRoleModuleField(
                  moduleNames: moduleNames,
                  formModule: formModule,
                  modulesLoading: modulesLoading,
                  modulesError: modulesError,
                  onModuleChanged: notifier.updateFormModule,
                ),
              ),
            ],
          ),
          Gap(18.h),
          DigifySelectFieldWithLabel<ActiveInactiveStatus>(
            label: 'Status',
            isRequired: true,
            items: ActiveInactiveStatus.values,
            value: state.formStatus,
            itemLabelBuilder: (item) => item.label,
            onChanged: notifier.updateFormStatus,
          ),
        ],
        Gap(18.h),
        DigifyTextArea(
          controller: descriptionController,
          labelText: 'Description',
          hintText: 'Describe this function role',
          maxLines: 4,
        ),
      ],
    );
  }
}
