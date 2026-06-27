import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/workforce_structure/data/mappers/ent_lookup_value_mapper.dart';
import 'package:grc/features/workforce_structure/domain/models/ent_lookup_value_input.dart';
import 'package:grc/features/workforce_structure/presentation/providers/create_ent_lookup_value_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/create_grade_form_state_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/ent_lookup_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../gen/assets.gen.dart';

class _PendingLookupItem {
  const _PendingLookupItem({required this.lookupCode, required this.meaningEn});

  final String lookupCode;
  final String meaningEn;

  String chipLabel() => '$meaningEn ($lookupCode)';

  EntLookupValueInput toInput() => EntLookupValueInput(lookupCode: lookupCode, meaningEn: meaningEn);
}

class CreateEntLookupValueDialog extends ConsumerStatefulWidget {
  const CreateEntLookupValueDialog({
    super.key,
    required this.lookupTypeCode,
    required this.title,
    required this.fieldLabel,
    this.isSheet = false,
  });

  final String lookupTypeCode;
  final String title;
  final String fieldLabel;
  final bool isSheet;

  static Future<void> show(
    BuildContext context, {
    required String lookupTypeCode,
    required String title,
    required String fieldLabel,
  }) {
    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: CreateEntLookupValueDialog(
          lookupTypeCode: lookupTypeCode,
          title: title,
          fieldLabel: fieldLabel,
          isSheet: true,
        ),
      );
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CreateEntLookupValueDialog(lookupTypeCode: lookupTypeCode, title: title, fieldLabel: fieldLabel),
    );
  }

  @override
  ConsumerState<CreateEntLookupValueDialog> createState() => _CreateEntLookupValueDialogState();
}

class _CreateEntLookupValueDialogState extends ConsumerState<CreateEntLookupValueDialog> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final List<_PendingLookupItem> _pendingValues = [];

  bool get _isGradeCategory => widget.lookupTypeCode == 'GRADE_CATEGORY';

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addValue() {
    if (_isGradeCategory) {
      _addGradeCategoryValue();
      return;
    }
    _addGradeNumberValue();
  }

  void _addGradeCategoryValue() {
    final l10n = AppLocalizations.of(context)!;
    final code = _codeController.text.trim();
    final name = _nameController.text.trim();

    if (code.isEmpty || name.isEmpty) {
      ToastService.error(context, l10n.lookupValueRequired);
      return;
    }

    final normalizedCode = code.toUpperCase();
    if (_pendingValues.any((v) => v.lookupCode.toUpperCase() == normalizedCode)) {
      ToastService.error(context, l10n.lookupValueDuplicate);
      return;
    }

    setState(() {
      _pendingValues.add(_PendingLookupItem(lookupCode: code, meaningEn: name));
      _codeController.clear();
      _nameController.clear();
    });
  }

  void _addGradeNumberValue() {
    final l10n = AppLocalizations.of(context)!;
    final name = _codeController.text.trim();

    if (name.isEmpty) {
      ToastService.error(context, l10n.lookupValueRequired);
      return;
    }

    final category = ref.read(createGradeFormStateProvider).selectedGradeCategory;
    if (category == null) {
      ToastService.error(context, l10n.selectGradeCategoryFirst);
      return;
    }

    final normalizedName = name.toLowerCase();
    if (_pendingValues.any((v) => v.meaningEn.toLowerCase() == normalizedName)) {
      ToastService.error(context, l10n.lookupValueDuplicate);
      return;
    }

    final prefix = category.lookupCode.trim().toUpperCase();
    final existingCodes = (ref.read(gradeNumberLookupValuesProvider).value ?? [])
        .where((value) => value.lookupCode.trim().toUpperCase().startsWith(prefix))
        .map((value) => value.lookupCode);
    final pendingCodes = _pendingValues.map((value) => value.lookupCode);
    final nextSequence = EntLookupValueMapper.nextGradeNumberSequence(
      categoryCode: category.lookupCode,
      existingLookupCodes: existingCodes,
      pendingLookupCodes: pendingCodes,
    );
    final lookupCode = EntLookupValueMapper.gradeNumberLookupCodeForSequence(category.lookupCode, nextSequence);

    setState(() {
      _pendingValues.add(_PendingLookupItem(lookupCode: lookupCode, meaningEn: name));
      _codeController.clear();
    });
  }

  void _removeValue(_PendingLookupItem value) {
    setState(() => _pendingValues.remove(value));
  }

  Future<void> _handleCreate() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pendingValues.isEmpty) {
      ToastService.error(context, l10n.lookupValueRequired);
      return;
    }

    final errorMessage = await ref
        .read(createEntLookupValueProvider.notifier)
        .submit(lookupTypeCode: widget.lookupTypeCode, values: _pendingValues.map((item) => item.toInput()).toList());

    if (!mounted) return;

    if (errorMessage == null) {
      ToastService.success(context, l10n.lookupValuesCreatedSuccessfully);
      context.pop();
      return;
    }

    ToastService.error(context, errorMessage.isNotEmpty ? errorMessage : l10n.errorCreatingLookupValues);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isCreating = ref.watch(createEntLookupValueProvider).isLoading;

    final formContent = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isGradeCategory) ...[
          DigifyTextField(
            controller: _nameController,
            labelText: l10n.gradeCategoryNameLabel,
            hintText: l10n.gradeCategoryNameHint,
            isRequired: true,
            textInputAction: TextInputAction.next,
          ),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: _codeController,
                  labelText: l10n.gradeCategoryCodeLabel,
                  hintText: l10n.gradeCategoryCodeHint,
                  isRequired: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addValue(),
                ),
              ),
              Gap(12.w),
              AppMobileButton.primary(
                svgPath: Assets.icons.addDivisionIcon.path,
                onPressed: isCreating ? null : _addValue,
              ),
            ],
          ),
        ] else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: DigifyTextField(
                  controller: _codeController,
                  labelText: widget.fieldLabel,
                  hintText: l10n.gradeNumberInputHint,
                  isRequired: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _addValue(),
                ),
              ),
              Gap(12.w),
              AppMobileButton.primary(
                svgPath: Assets.icons.addDivisionIcon.path,
                onPressed: isCreating ? null : _addValue,
              ),
            ],
          ),
        if (_pendingValues.isNotEmpty) ...[
          Gap(16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _pendingValues.map((value) {
              return DigifyCapsule(
                label: value.chipLabel(),
                iconPath: Assets.icons.closeDialogIcon.path,
                onTap: isCreating ? null : () => _removeValue(value),
                borderRadius: 8.r,
                backgroundColor: AppColors.infoBg,
                textColor: AppColors.primary,
              );
            }).toList(),
          ),
        ],
      ],
    );

    if (widget.isSheet) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
              child: formContent,
            ),
          ),
          const DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outline(label: l10n.cancel, onPressed: isCreating ? null : () => context.pop()),
                ),
                Gap(12.w),
                Expanded(
                  child: AppButton.primary(label: l10n.create, onPressed: _handleCreate, isLoading: isCreating),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AppDialog(
      title: widget.title,
      width: 520.w,
      content: formContent,
      actions: [
        AppButton.outline(label: l10n.cancel, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(label: l10n.create, onPressed: _handleCreate, isLoading: isCreating),
      ],
    );
  }
}
