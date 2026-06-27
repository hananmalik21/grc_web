import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/utils/duration_formatter.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/presentation/providers/update_shift_form_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/create_shift_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/widgets/update_shift_form_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UpdateShiftMobileSheet extends ConsumerStatefulWidget {
  final ShiftOverview shift;
  final int enterpriseId;

  const UpdateShiftMobileSheet({super.key, required this.shift, required this.enterpriseId});

  static Future<void> show(BuildContext context, ShiftOverview shift, {required int enterpriseId}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Update Shift',
      barrierDismissible: false,
      child: UpdateShiftMobileSheet(shift: shift, enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<UpdateShiftMobileSheet> createState() => _UpdateShiftMobileSheetState();
}

class _UpdateShiftMobileSheetState extends ConsumerState<UpdateShiftMobileSheet> {
  late final TextEditingController _codeController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameArController;
  late final TextEditingController _durationController;
  late final TextEditingController _breakDurationController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.shift.code);
    _nameEnController = TextEditingController(text: widget.shift.name);
    _nameArController = TextEditingController(text: widget.shift.nameAr);
    _durationController = TextEditingController(text: DurationFormatter.formatHours(widget.shift.totalHours));
    _breakDurationController = TextEditingController(text: '1');
  }

  void _onFormStateChanged(UpdateShiftFormState? prev, UpdateShiftFormState next) {
    if (prev?.duration != next.duration && next.duration.isNotEmpty) {
      _durationController.text = next.duration;
    }
    if (prev?.breakDuration != next.breakDuration) {
      _breakDurationController.text = next.breakDuration;
    }
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

  Future<void> _handleUpdate() async {
    final params = (shift: widget.shift, enterpriseId: widget.enterpriseId);
    final formNotifier = ref.read(updateShiftFormProvider(params).notifier);
    final updatedShift = await formNotifier.updateShift();

    if (!mounted) return;

    if (updatedShift != null) {
      ToastService.success(context, 'Shift updated successfully', title: 'Success');
      context.pop();
    } else {
      final formState = ref.read(updateShiftFormProvider(params));
      if (formState.errors.isNotEmpty) {
        ToastService.error(context, formState.errors.values.first, title: 'Validation Error');
      } else if (formState.errorMessage != null) {
        ToastService.error(context, formState.errorMessage!, title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final params = (shift: widget.shift, enterpriseId: widget.enterpriseId);
    final formState = ref.watch(updateShiftFormProvider(params));
    ref.listen(updateShiftFormProvider(params), _onFormStateChanged);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: UpdateShiftFormContent(
              shift: widget.shift,
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
          actionLabel: 'Update Shift',
          actionIcon: Assets.icons.saveIcon.path,
          isLoading: formState.isLoading,
          onCancel: formState.isLoading ? null : () => context.pop(),
          onAction: formState.isLoading ? null : _handleUpdate,
        ),
      ],
    );
  }
}
