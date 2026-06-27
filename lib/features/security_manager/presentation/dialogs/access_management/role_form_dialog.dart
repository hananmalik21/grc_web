import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_checkbox.dart';
import '../../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../../core/widgets/forms/digify_select_field.dart';
import '../../../../../core/widgets/forms/digify_select_field_with_label.dart';
import '../../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../data/models/access_management/access_role.dart';
import '../../providers/access_management/access_role_form_provider.dart';
import '../../widgets/access_management/access_section_card.dart';

class RoleFormDialog extends ConsumerStatefulWidget {
  const RoleFormDialog({super.key, this.roleDetail});

  final AccessRoleDetail? roleDetail;

  static void show(BuildContext context, {AccessRoleDetail? roleDetail}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => RoleFormDialog(roleDetail: roleDetail),
    );
  }

  @override
  ConsumerState<RoleFormDialog> createState() => _RoleFormDialogState();
}

class _RoleFormDialogState extends ConsumerState<RoleFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _roleNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _searchPermissionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.roleDetail != null) {
      _roleNameController.text = widget.roleDetail!.name;
      _descriptionController.text = widget.roleDetail!.description;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(accessRoleFormProvider.notifier)
          .setInitialData(widget.roleDetail);
    });
  }

  @override
  void dispose() {
    _roleNameController.dispose();
    _descriptionController.dispose();
    _searchPermissionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accessRoleFormProvider);
    final notifier = ref.read(accessRoleFormProvider.notifier);

    return AppDialog(
      title: widget.roleDetail == null ? 'Create New Role' : 'Edit Role',
      width: 500.w,
      onClose: () {
        notifier.resetForm();
        context.pop();
      },
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTextField(
              controller: _roleNameController,
              labelText: 'Role Name',
              isRequired: true,
              onChanged: (value) => notifier.setRoleName(value),
              hintText: 'e.g. HR Admin, Manager etc.',
            ),
            Gap(16.h),
            DigifyTextArea(
              controller: _descriptionController,
              maxLines: 3,
              labelText: 'Description',
              onChanged: (value) => notifier.setRoleDescription(value),
              hintText: 'Describe the role',
            ),
            Gap(16.h),
            if (context.isMobile) ...[
              DigifySelectField(
                items: ['Admin', 'Standard', 'Manager'],
                label: 'Role Type',
                value: state.roleType,
                itemLabelBuilder: (item) => item,
                onChanged: (value) => notifier.setRoleType(value!),
              ),
              Gap(16.h),
              DigifySelectField(
                items: ['Active', 'Inactive'],
                label: 'Status',
                value: state.status,
                itemLabelBuilder: (item) => item,
                onChanged: (value) => notifier.setStatus(value!),
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: DigifySelectFieldWithLabel(
                      items: ['Admin', 'Standard', 'Manager'],
                      label: 'Role Type',
                      value: state.roleType,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) => notifier.setRoleType(value!),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifySelectFieldWithLabel(
                      items: ['Active', 'Inactive'],
                      label: 'Status',
                      value: state.status,
                      itemLabelBuilder: (item) => item,
                      onChanged: (value) => notifier.setStatus(value!),
                    ),
                  ),
                ],
              ),
            ],
            Gap(16.h),
            AccessSectionCard(
              title: 'Permission Matrix',
              child: Column(
                children: [
                  DigifyTextField.search(
                    controller: _searchPermissionController,
                    hintText: 'Search modules...',
                    onChanged: (value) => notifier.searchPermissions(value),
                  ),
                  Gap(16.h),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: context.isDark
                                  ? AppColors.cardBorderDark
                                  : AppColors.cardBorder,
                            ),
                            bottom: BorderSide(
                              color: context.isDark
                                  ? AppColors.cardBorderDark
                                  : AppColors.cardBorder,
                            ),
                          ),
                        ),
                        children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Module',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              alignment: Alignment.center,
                              child: Text(
                                "View",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              alignment: Alignment.center,
                              child: Text(
                                "Create",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              alignment: Alignment.center,
                              child: Text(
                                "Edit",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              alignment: Alignment.center,
                              child: Text(
                                "Delete",
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (AccessRolePermission module
                          in state.filteredPermissions)
                        TableRow(
                          children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  module.name,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                alignment: Alignment.center,
                                child: DigifyCheckbox(
                                  value: module.view,
                                  onChanged: (value) => notifier
                                      .updatePermission(module.id, view: value),
                                  alignment: MainAxisAlignment.center,
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                alignment: Alignment.center,
                                child: DigifyCheckbox(
                                  value: module.create,
                                  onChanged: (value) =>
                                      notifier.updatePermission(
                                        module.id,
                                        create: value,
                                      ),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                alignment: Alignment.center,
                                child: DigifyCheckbox(
                                  value: module.edit,
                                  onChanged: (value) => notifier
                                      .updatePermission(module.id, edit: value),
                                ),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                alignment: Alignment.center,
                                child: DigifyCheckbox(
                                  value: module.delete,
                                  onChanged: (value) =>
                                      notifier.updatePermission(
                                        module.id,
                                        delete: value,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          onPressed: () {
            notifier.resetForm();
            context.pop();
          },
          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textSecondary,
        ),
        Gap(12.w),
        AppButton(
          label: widget.roleDetail == null ? 'Create Role' : 'Update Role',
          onPressed: () {},
          svgPath: Assets.icons.saveConfigIcon.path,
          type: AppButtonType.primary,
        ),
      ],
    );
  }
}
