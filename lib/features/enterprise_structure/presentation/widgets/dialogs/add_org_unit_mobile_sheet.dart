import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_unit_form_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/parent_org_unit_picker_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/parent_org_unit_selection_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddOrgUnitMobileSheet extends ConsumerStatefulWidget {
  final String structureId;
  final String levelCode;
  final OrgStructureLevel? initialValue;

  const AddOrgUnitMobileSheet({super.key, required this.structureId, required this.levelCode, this.initialValue});

  static Future<void> show(
    BuildContext context, {
    required String structureId,
    required String levelCode,
    OrgStructureLevel? initialValue,
  }) {
    final title = initialValue == null
        ? 'Add New ${levelCode.capitalizeEachWord}'
        : 'Edit ${levelCode.capitalizeEachWord}';

    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: title,
      barrierDismissible: false,
      child: AddOrgUnitMobileSheet(structureId: structureId, levelCode: levelCode, initialValue: initialValue),
    );
  }

  @override
  ConsumerState<AddOrgUnitMobileSheet> createState() => _AddOrgUnitMobileSheetState();
}

class _AddOrgUnitMobileSheetState extends ConsumerState<AddOrgUnitMobileSheet> {
  final List<String> _statusOptions = ['Active', 'Inactive'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orgUnitFormProvider.notifier).initialize(widget.initialValue);
    });
  }

  Future<void> _selectParent() async {
    if (widget.levelCode.toUpperCase() == 'COMPANY') return;

    final selected = await ParentOrgUnitPickerDialog.show(
      context,
      structureId: widget.structureId,
      levelCode: widget.levelCode,
      selectedParentId: ref.read(orgUnitFormProvider).parentId,
    );
    if (selected != null && mounted) {
      ref.read(orgUnitFormProvider.notifier).updateParent(selected);
    }
  }

  Future<void> _handleSubmit() async {
    await ref
        .read(orgUnitFormProvider.notifier)
        .submit(
          structureId: widget.structureId,
          orgUnitId: widget.initialValue?.orgUnitId,
          levelCode: widget.levelCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(orgUnitFormProvider);
    final notifier = ref.read(orgUnitFormProvider.notifier);

    ref.listen<OrgUnitFormState>(orgUnitFormProvider, (previous, next) {
      if (next.success && mounted) {
        Navigator.of(context).pop();
        ToastService.success(
          context,
          widget.initialValue != null ? 'Org unit updated successfully' : 'Org unit created successfully',
        );
      } else if (next.error != null && mounted) {
        ToastService.error(context, next.error!);
      }
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyTextField(
                  controller: notifier.getController('orgUnitCode'),
                  labelText: 'Org Unit Code',
                  hintText: 'Enter org unit code',
                  enabled: !formState.isLoading,
                  isRequired: true,
                  inputFormatters: [AppInputFormatters.orgUnitCode, AppInputFormatters.maxLen(30)],
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: notifier.getController('nameEn'),
                  labelText: localizations.nameEnglish,
                  hintText: 'Enter name in English',
                  enabled: !formState.isLoading,
                  isRequired: true,
                  inputFormatters: [AppInputFormatters.nameEn, AppInputFormatters.maxLen(120)],
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: notifier.getController('nameAr'),
                  labelText: localizations.nameArabic,
                  hintText: 'Enter name in Arabic (Optional)',
                  enabled: !formState.isLoading,
                  inputFormatters: [AppInputFormatters.nameAny, AppInputFormatters.maxLen(120)],
                ),
                Gap(16.h),
                DigifySelectFieldWithLabel<String>(
                  label: localizations.status,
                  hint: 'Select status',
                  isRequired: true,
                  value: formState.selectedStatus,
                  items: _statusOptions,
                  itemLabelBuilder: (item) => item,
                  onChanged: formState.isLoading
                      ? null
                      : (String? newValue) {
                          if (newValue != null) {
                            notifier.updateStatus(newValue);
                          }
                        },
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: notifier.getController('address'),
                  labelText: localizations.address,
                  hintText: 'Enter address',
                  enabled: !formState.isLoading,
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: notifier.getController('city'),
                  labelText: localizations.city,
                  hintText: 'Enter city',
                  enabled: !formState.isLoading,
                ),
                if (widget.levelCode.toUpperCase() != 'COMPANY') ...[
                  Gap(16.h),
                  ParentOrgUnitSelectionField(
                    parentName: formState.parentName,
                    onTap: _selectParent,
                    isLoading: formState.isLoading,
                    isRequired: true,
                  ),
                ],
                Gap(16.h),
                DigifyTextArea(
                  controller: notifier.getController('description'),
                  labelText: localizations.description,
                  hintText: 'Enter description',
                  maxLines: 3,
                  enabled: !formState.isLoading,
                ),
              ],
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(
                label: localizations.cancel,
                onPressed: formState.isLoading ? null : () => Navigator.of(context).pop(),
              ),
              Gap(12.w),
              Expanded(
                child: AppButton.primary(
                  label: localizations.saveConfiguration,
                  svgPath: Assets.icons.saveConfigIcon.path,
                  isLoading: formState.isLoading,
                  onPressed: formState.isLoading ? null : _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
