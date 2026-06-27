import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/developer_tools/presentation/providers/create_function_form_provider.dart';
import 'package:grc/features/developer_tools/presentation/widgets/function_management/create_function_dialog_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateFunctionDialog extends ConsumerWidget with CreateFunctionDialogMixin {
  const CreateFunctionDialog({super.key, required this.isMobileSheet});

  final bool isMobileSheet;

  static Future<bool> show(BuildContext context) async {
    if (ResponsiveHelper.isMobile(context)) {
      final result = await DigifyBottomSheet.show<bool>(
        context,
        type: DigifyBottomSheetType.custom,
        title: 'Create Function',
        barrierDismissible: false,
        child: const CreateFunctionDialog(isMobileSheet: true),
      );
      return result == true;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateFunctionDialog(isMobileSheet: false),
    );
    return result == true;
  }

  Widget _buildFormContent(BuildContext context, WidgetRef ref, CreateFunctionFormState state) {
    final notifier = ref.read(createFunctionFormProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField(
          labelText: 'Function Name',
          hintText: 'Enter function name',
          isRequired: true,
          onChanged: notifier.updateFunctionName,
        ),
        Gap(14.h),
        DigifyTextField(
          labelText: 'Function Code',
          hintText: 'Enter function code',
          isRequired: true,
          onChanged: notifier.updateFunctionCode,
        ),
        Gap(14.h),
        DigifyTextArea(
          labelText: 'Description',
          hintText: 'Enter description',
          maxLines: 3,
          onChanged: notifier.updateDescription,
        ),
        Gap(14.h),
        DigifySelectionFieldWithLabel(
          label: 'Select Module',
          hint: 'Choose module',
          isRequired: true,
          value: state.selectedModule?.moduleName,
          onTap: () => openModuleDialog(context, ref, state),
        ),
        Gap(14.h),
        DigifySelectionFieldWithLabel(
          label: 'Select Submodule',
          hint: state.selectedModule == null ? 'Select module first' : 'Choose submodule',
          isRequired: true,
          value: state.selectedSubmodule?.subModuleName,
          isEnabled: state.selectedModule != null,
          onTap: () => openSubmoduleDialog(context, ref, state),
        ),
        Gap(14.h),
        DigifySelectionFieldWithLabel(
          label: 'Select Action',
          hint: 'Choose action',
          isRequired: true,
          value: state.selectedAction?.actionName,
          isEnabled: state.selectedSubmodule != null,
          onTap: () => openActionDialog(context, ref, state),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createFunctionFormProvider);

    if (!isMobileSheet) {
      return AppDialog(
        title: 'Create Function',
        subtitle: 'Configure function and access scope',
        width: 640.w,
        content: _buildFormContent(context, ref, state),
        actions: [
          AppButton.outline(
            label: 'Cancel',
            onPressed: state.isLoading ? null : () => Navigator.of(context).pop(false),
          ),
          Gap(12.w),
          AppButton.primary(
            label: 'Create',
            isLoading: state.isLoading,
            onPressed: state.isLoading ? null : () => handleCreate(context, ref, state),
          ),
        ],
      );
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 10.h),
            child: _buildFormContent(context, ref, state),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: 'Cancel',
                  onPressed: state.isLoading ? null : () => Navigator.of(context).pop(false),
                ),
              ),
              Gap(10.w),
              Expanded(
                child: AppButton.primary(
                  label: 'Create',
                  isLoading: state.isLoading,
                  onPressed: state.isLoading ? null : () => handleCreate(context, ref, state),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
