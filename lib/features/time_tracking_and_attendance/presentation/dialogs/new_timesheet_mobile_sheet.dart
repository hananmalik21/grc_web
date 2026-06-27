import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_basic_form.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_table.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/new_timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewTimesheetMobileSheet {
  NewTimesheetMobileSheet._();

  static Future<void> show(BuildContext context) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'New Weekly Timesheet',
      barrierDismissible: false,
      child: ProviderScope(
        overrides: [newTimesheetProvider.overrideWith((ref) => NewTimesheetNotifier(ref))],
        child: const _NewTimesheetSheetBody(),
      ),
    );
  }
}

class _NewTimesheetSheetBody extends ConsumerStatefulWidget {
  const _NewTimesheetSheetBody();

  @override
  ConsumerState<_NewTimesheetSheetBody> createState() => _NewTimesheetSheetBodyState();
}

class _NewTimesheetSheetBodyState extends ConsumerState<_NewTimesheetSheetBody> {
  late final TextEditingController _employeeNameController;
  late final TextEditingController _positionController;
  late final TextEditingController _departmentController;
  late final TextEditingController _descriptionController;
  late final List<TextEditingController> _regularHoursControllers;
  late final List<TextEditingController> _overtimeHoursControllers;

  @override
  void initState() {
    super.initState();
    _employeeNameController = TextEditingController();
    _positionController = TextEditingController();
    _departmentController = TextEditingController();
    _descriptionController = TextEditingController();
    _regularHoursControllers = List.generate(7, (_) => TextEditingController(text: '0'));
    _overtimeHoursControllers = List.generate(7, (_) => TextEditingController(text: '0'));
  }

  @override
  void dispose() {
    _employeeNameController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    _descriptionController.dispose();
    for (final c in _regularHoursControllers) {
      c.dispose();
    }
    for (final c in _overtimeHoursControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newTimesheetProvider);
    final notifier = ref.read(newTimesheetProvider.notifier);
    final enterpriseId = ref.watch(timesheetEnterpriseIdProvider);

    _employeeNameController.text = state.employeeName ?? '';
    _positionController.text = state.position ?? '';
    _departmentController.text = state.departmentId ?? '';
    _descriptionController.text = state.description ?? '';

    for (var i = 0; i < state.weekDays.length && i < 7; i++) {
      final regular = i < state.regularHours.length ? state.regularHours[i] : 0.0;
      final overtime = i < state.overtimeHours.length ? state.overtimeHours[i] : 0.0;
      final regularText = regular == regular.roundToDouble() ? regular.toInt().toString() : regular.toStringAsFixed(2);
      final overtimeText = overtime == overtime.roundToDouble()
          ? overtime.toInt().toString()
          : overtime.toStringAsFixed(2);
      if (_regularHoursControllers[i].text != regularText) {
        _regularHoursControllers[i].text = regularText;
      }
      if (_overtimeHoursControllers[i].text != overtimeText) {
        _overtimeHoursControllers[i].text = overtimeText;
      }
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NewTimesheetBasicForm(
                  state: state,
                  notifier: notifier,
                  enterpriseId: enterpriseId,
                  employeeNameController: _employeeNameController,
                  positionController: _positionController,
                  departmentController: _departmentController,
                  descriptionController: _descriptionController,
                ),
                Gap(24.h),
                NewTimesheetTable(
                  state: state,
                  notifier: notifier,
                  regularHoursControllers: _regularHoursControllers,
                  overtimeHoursControllers: _overtimeHoursControllers,
                ),
                Gap(8.h),
              ],
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        _ActionBar(
          isSavingDraft: state.isSavingDraft,
          isSubmitting: state.isSubmittingForApproval,
          onSaveDraft: () => _handleSubmit(TimesheetStatus.draft),
          onSubmit: () => _handleSubmit(TimesheetStatus.submitted),
        ),
      ],
    );
  }

  Future<void> _handleSubmit(TimesheetStatus status) async {
    final notifier = ref.read(newTimesheetProvider.notifier);
    try {
      await notifier.submit(status);
      if (!mounted) return;
      ToastService.success(context, 'Timesheet saved successfully.');
      Navigator.of(context).pop();
    } on MissingTimesheetRequiredDataException {
      if (!mounted) return;
      ToastService.error(context, 'Missing required data to create timesheet.');
    } catch (_) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to save timesheet. Please try again.');
    }
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({
    required this.isSavingDraft,
    required this.isSubmitting,
    required this.onSaveDraft,
    required this.onSubmit,
  });

  final bool isSavingDraft;
  final bool isSubmitting;
  final VoidCallback onSaveDraft;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final busy = isSavingDraft || isSubmitting;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10.h,
        children: [
          AppButton(
            label: 'Submit for Approval',
            isLoading: isSubmitting,
            onPressed: busy ? null : onSubmit,
            svgPath: Assets.icons.submitted.path,
            type: AppButtonType.primary,
          ),
          AppButton(
            label: 'Save as Draft',
            isLoading: isSavingDraft,
            onPressed: busy ? null : onSaveDraft,
            svgPath: Assets.icons.saveDivisionIcon.path,
            type: AppButtonType.outline,
            backgroundColor: AppColors.cardBackground,
            foregroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
