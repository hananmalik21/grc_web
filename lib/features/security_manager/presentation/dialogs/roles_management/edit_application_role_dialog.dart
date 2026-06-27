import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditApplicationRoleDialog extends ConsumerStatefulWidget {
  const EditApplicationRoleDialog({super.key, required this.role});

  final RoleModel role;

  static Future<void> show(BuildContext context, {required RoleModel role}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => EditApplicationRoleDialog(role: role),
    );
  }

  @override
  ConsumerState<EditApplicationRoleDialog> createState() => _EditApplicationRoleDialogState();
}

class _EditApplicationRoleDialogState extends ConsumerState<EditApplicationRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _roleNameController;
  late final TextEditingController _descriptionController;
  late String _roleType;

  static const List<String> _roleTypeOptions = ['System Role', 'Custom Role'];

  @override
  void initState() {
    super.initState();
    _roleNameController = TextEditingController(text: widget.role.name);
    _descriptionController = TextEditingController(text: widget.role.description);
    _roleType = widget.role.roleBadge;
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Edit Role',
      subtitle: 'Modify role details and permissions',
      width: 560.w,
      onClose: () => context.pop(),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTextField(
              controller: _roleNameController,
              labelText: 'Role Name',
              hintText: 'Enter role name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Role name is required';
                return null;
              },
            ),
            Gap(18.h),
            DigifyTextArea(
              controller: _descriptionController,
              labelText: 'Description',
              hintText: 'Describe the role',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Description is required';
                return null;
              },
            ),
            Gap(18.h),
            DigifySelectFieldWithLabel<String>(
              label: 'Role Type',
              items: _roleTypeOptions,
              value: _roleType,
              itemLabelBuilder: (item) => item,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _roleType = value);
                }
              },
            ),
            Gap(18.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(color: AppColors.infoBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: DigifyAsset(
                      assetPath: Assets.icons.infoCircleBlue.path,
                      width: 17,
                      height: 17,
                      color: AppColors.infoText,
                    ),
                  ),
                  Gap(10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Note',
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.infoText,
                          ),
                        ),
                        Gap(4.h),
                        Text(
                          'Changes to this role will affect all ${widget.role.usersAssigned} assigned users. Please review carefully before saving.',
                          style: context.textTheme.bodySmall?.copyWith(color: AppColors.roleActionBlue, height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        const Spacer(),
        AppButton(
          label: 'Cancel',
          onPressed: () => context.pop(),
          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textDarkSlate,
          borderColor: AppColors.borderGrey,
        ),
        Gap(10.w),
        AppButton(label: 'Save Changes', onPressed: _handleSave, type: AppButtonType.primary),
      ],
    );
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final updatedRole = widget.role.copyWith(
      name: _roleNameController.text.trim(),
      description: _descriptionController.text.trim(),
      roleBadge: _roleType,
      updatedLabel: 'Updated just now',
    );

    ref.read(rolesManagementProvider.notifier).updateRole(updatedRole);

    context.pop();
    ToastService.success(context, 'Changes saved successfully', title: 'Saved Changes');
  }
}
