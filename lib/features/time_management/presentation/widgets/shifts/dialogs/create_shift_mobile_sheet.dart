import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_management/presentation/providers/shift_form_provider.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/widgets/shift_form_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateShiftMobileSheet extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateShiftMobileSheet({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, {required int enterpriseId}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Create New Shift',
      barrierDismissible: false,
      child: CreateShiftMobileSheet(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateShiftMobileSheet> createState() => _CreateShiftMobileSheetState();
}

class _CreateShiftMobileSheetState extends ConsumerState<CreateShiftMobileSheet> {
  final _codeController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameArController = TextEditingController();
  final _durationController = TextEditingController();
  final _breakDurationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _breakDurationController.text = '1';
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameEnController.dispose();
    _nameArController.dispose();
    _durationController.dispose();
    _breakDurationController.dispose();
    super.dispose();
  }

  Future<void> _handleCreate() async {
    final formNotifier = ref.read(shiftFormProvider(widget.enterpriseId).notifier);
    final shiftsNotifier = ref.read(shiftsNotifierProvider(widget.enterpriseId).notifier);

    final createdShift = await formNotifier.createShift();

    if (!mounted) return;

    if (createdShift != null) {
      shiftsNotifier.addShiftOptimistically(createdShift);
      ToastService.success(context, 'Shift created successfully', title: 'Success');
      Navigator.of(context).pop();
    } else {
      final formState = ref.read(shiftFormProvider(widget.enterpriseId));
      if (formState.errors.isNotEmpty) {
        ToastService.error(context, formState.errors.values.first, title: 'Validation Error');
      } else if (formState.errorMessage != null) {
        ToastService.error(context, formState.errorMessage!, title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(shiftFormProvider(widget.enterpriseId));

    if (formState.duration.isNotEmpty && _durationController.text != formState.duration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _durationController.text = formState.duration;
      });
    }
    if (formState.breakDuration.isNotEmpty && _breakDurationController.text != formState.breakDuration) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _breakDurationController.text = formState.breakDuration;
      });
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: ShiftFormContent(
              codeController: _codeController,
              nameEnController: _nameEnController,
              nameArController: _nameArController,
              durationController: _durationController,
              breakDurationController: _breakDurationController,
              enterpriseId: widget.enterpriseId,
            ),
          ),
        ),
        ShiftSheetFooter(
          cancelLabel: 'Cancel',
          actionLabel: 'Create Shift',
          actionIcon: Assets.icons.saveIcon.path,
          isLoading: formState.isLoading,
          onCancel: () {
            ref.read(shiftFormProvider(widget.enterpriseId).notifier).reset();
            Navigator.of(context).pop();
          },
          onAction: formState.isLoading ? null : _handleCreate,
        ),
      ],
    );
  }
}

class ShiftSheetFooter extends StatelessWidget {
  final String cancelLabel;
  final String actionLabel;
  final String actionIcon;
  final bool isLoading;
  final VoidCallback? onCancel;
  final VoidCallback? onAction;

  const ShiftSheetFooter({
    super.key,
    required this.cancelLabel,
    required this.actionLabel,
    required this.actionIcon,
    required this.isLoading,
    required this.onCancel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(label: cancelLabel, onPressed: onCancel, height: 46),
              Gap(10.w),
              Expanded(
                child: AppButton(
                  label: actionLabel,
                  svgPath: actionIcon,
                  isLoading: isLoading,
                  onPressed: onAction,
                  backgroundColor: AppColors.primary,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
