import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/toast_service.dart';
import '../../../../core/widgets/assets/digify_asset.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_dialog.dart';
import '../../../../core/widgets/forms/digify_text_field.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/models/overtime_configuration/rate_multiplier.dart';
import '../providers/overtime_configuration/rate_multiplier_provider.dart';

class OvertimeRateMultiplierDialog extends ConsumerStatefulWidget {
  const OvertimeRateMultiplierDialog({super.key, this.rateMultiplier});

  final RateMultiplier? rateMultiplier;

  static void show(BuildContext context, {RateMultiplier? rateMultiplier}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => OvertimeRateMultiplierDialog(rateMultiplier: rateMultiplier),
    );
  }

  @override
  ConsumerState<OvertimeRateMultiplierDialog> createState() => _OvertimeRateDialogState();
}

class _OvertimeRateDialogState extends ConsumerState<OvertimeRateMultiplierDialog> {
  final _formKey = GlobalKey<FormState>();

  final _rateCodeController = TextEditingController();
  final _rateTypeNameController = TextEditingController();
  final _multiplierController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rateCodeController.text = widget.rateMultiplier?.rateCode ?? '';
    _rateTypeNameController.text = widget.rateMultiplier?.rateName ?? '';
    _multiplierController.text = widget.rateMultiplier?.multiplier ?? '';
    _categoryController.text = widget.rateMultiplier?.categoryCode ?? '';
    _descriptionController.text = widget.rateMultiplier?.rateDescription ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rateMultiplierDialogProvider.notifier).setInitialData(widget.rateMultiplier);
    });
  }

  @override
  void dispose() {
    _rateTypeNameController.dispose();
    _multiplierController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(rateMultiplierDialogProvider.select((state) => state.isLoading));
    final notifier = ref.read(rateMultiplierDialogProvider.notifier);
    return AppDialog(
      title: widget.rateMultiplier != null ? 'Edit Rate' : 'Add Custom Overtime Rate',
      icon: DigifyAsset(assetPath: Assets.icons.addNewIconFigma.path, color: AppColors.buttonTextLight),
      width: 500.w,
      onClose: () => context.pop(),
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTextField(
              controller: _rateCodeController,
              labelText: 'Rate Type Code',
              onChanged: (value) => notifier.updateRateCode(value),
              hintText: 'e.g. OT-001',
            ),
            Gap(16.h),
            DigifyTextField(
              controller: _rateTypeNameController,
              labelText: 'Rate Type Name',
              onChanged: (value) => notifier.updateRateTypeName(value),
              hintText: 'e.g. Special Project Rate',
            ),
            Gap(16.h),
            if (context.isMobile) ...[
              DigifyTextField(
                controller: _multiplierController,
                onChanged: (value) => notifier.updateMultiplier(value),
                labelText: 'Multiplier',
                hintText: 'e.g. 1.5',
              ),
              Gap(16.h),
              DigifyTextField(
                controller: _categoryController,
                onChanged: (value) => notifier.updateCategory(value),
                labelText: 'Category',
                hintText: 'e.g. Weekday, Night',
              ),
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: DigifyTextField(
                      controller: _multiplierController,
                      labelText: 'Multiplier',
                      hintText: 'e.g. 1.5',
                      onChanged: (value) => notifier.updateMultiplier(value),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: DigifyTextField(
                      controller: _categoryController,
                      labelText: 'Category',
                      hintText: 'e.g. Weekday, Night',
                      onChanged: (value) => notifier.updateCategory(value),
                    ),
                  ),
                ],
              ),
            ],
            Gap(16.h),
            DigifyTextArea(
              controller: _descriptionController,
              onChanged: (value) => notifier.updateDescription(value),
              labelText: 'Description',
              hintText: 'Describe when this rate applies...',
            ),
            Gap(16.h),
          ],
        ),
      ),
      actions: [
        AppButton(
          label: 'Cancel',
          onPressed: () => context.pop(),

          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.textSecondary,
        ),
        Gap(12.w),
        AppButton(
          label: '${widget.rateMultiplier != null ? 'Update' : 'Save'} Rate Type',
          isLoading: isLoading,
          onPressed: () => _handleSubmit(ref),
          svgPath: Assets.icons.saveConfigIcon.path,
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  Future<void> _handleSubmit(WidgetRef ref) async {
    final notifier = ref.read(rateMultiplierDialogProvider.notifier);

    try {
      await notifier.handleSubmit(ref);
      if (!mounted) return;
      ToastService.success(
        context,
        'Rate Multiplier ${widget.rateMultiplier != null ? 'updated' : 'saved'} successfully.',
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ToastService.error(
        context,
        'Failed to ${widget.rateMultiplier != null ? 'update' : 'save'} rate multiplier. Please try again.',
      );
    }
  }
}
