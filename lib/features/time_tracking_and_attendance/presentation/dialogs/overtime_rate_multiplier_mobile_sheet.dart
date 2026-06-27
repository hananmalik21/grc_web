import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime_configuration/rate_multiplier.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime_configuration/rate_multiplier_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OvertimeRateMultiplierMobileSheet {
  OvertimeRateMultiplierMobileSheet._();

  static Future<void> show(BuildContext context, {RateMultiplier? rateMultiplier}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: rateMultiplier != null ? 'Edit Rate' : 'Add Custom Overtime Rate',
      barrierDismissible: false,
      child: _RateMultiplierSheetBody(rateMultiplier: rateMultiplier),
    );
  }
}

class _RateMultiplierSheetBody extends ConsumerStatefulWidget {
  const _RateMultiplierSheetBody({this.rateMultiplier});

  final RateMultiplier? rateMultiplier;

  @override
  ConsumerState<_RateMultiplierSheetBody> createState() => _RateMultiplierSheetBodyState();
}

class _RateMultiplierSheetBodyState extends ConsumerState<_RateMultiplierSheetBody> {
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
    _rateCodeController.dispose();
    _rateTypeNameController.dispose();
    _multiplierController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(rateMultiplierDialogProvider.select((s) => s.isLoading));
    final notifier = ref.read(rateMultiplierDialogProvider.notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h, bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DigifyTextField(
                  controller: _rateCodeController,
                  labelText: 'Rate Type Code',
                  onChanged: notifier.updateRateCode,
                  hintText: 'e.g. OT-001',
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: _rateTypeNameController,
                  labelText: 'Rate Type Name',
                  onChanged: notifier.updateRateTypeName,
                  hintText: 'e.g. Special Project Rate',
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: _multiplierController,
                  onChanged: notifier.updateMultiplier,
                  labelText: 'Multiplier',
                  hintText: 'e.g. 1.5',
                  keyboardType: TextInputType.number,
                ),
                Gap(16.h),
                DigifyTextField(
                  controller: _categoryController,
                  onChanged: notifier.updateCategory,
                  labelText: 'Category',
                  hintText: 'e.g. Weekday, Night',
                ),
                Gap(16.h),
                DigifyTextArea(
                  controller: _descriptionController,
                  onChanged: notifier.updateDescription,
                  labelText: 'Description',
                  hintText: 'Describe when this rate applies...',
                ),
              ],
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: '${widget.rateMultiplier != null ? 'Update' : 'Save'} Rate Type',
                svgPath: Assets.icons.saveConfigIcon.path,
                isLoading: isLoading,
                onPressed: isLoading ? null : _handleSubmit,
                type: AppButtonType.primary,
              ),
              Gap(10.h),
              AppButton(
                label: 'Cancel',
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                type: AppButtonType.outline,
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
