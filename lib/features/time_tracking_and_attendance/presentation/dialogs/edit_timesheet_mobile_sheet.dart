import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_basic_form.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_table.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/edit_timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditTimesheetMobileSheet {
  EditTimesheetMobileSheet._();

  static Future<void> show(BuildContext context, Timesheet timesheet) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Edit Timesheet',
      barrierDismissible: false,
      child: ProviderScope(
        overrides: [
          editTimesheetProvider.overrideWith((ref) {
            final initial = _initialStateFromTimesheet(timesheet);
            return EditTimesheetNotifier(ref, initial);
          }),
        ],
        child: const _EditTimesheetSheetBody(),
      ),
    );
  }

  static EditTimesheetFormState _initialStateFromTimesheet(Timesheet t) {
    final startDate = t.weekStartDate;
    final endDate = t.weekEndDate;
    final weekDays = List.generate(7, (i) => startDate.add(Duration(days: i)));
    String dateKey(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';

    final regularHours = List<double>.filled(7, 0.0);
    final overtimeHours = List<double>.filled(7, 0.0);
    final taskTexts = List<String>.filled(7, '');
    final lineIds = List<int?>.filled(7, null);
    final taskIds = List<int?>.filled(7, null);

    for (final line in t.lines) {
      final lineDate = line.workDate.length >= 10 ? line.workDate.substring(0, 10) : line.workDate;
      final idx = weekDays.indexWhere((d) => dateKey(d) == lineDate);
      if (idx >= 0 && idx < 7) {
        regularHours[idx] = line.regularHours;
        overtimeHours[idx] = line.overtimeHours;
        taskTexts[idx] = line.taskText;
        lineIds[idx] = line.lineId;
        taskIds[idx] = line.taskId;
      }
    }

    int? projectId;
    String? projectName;
    for (final l in t.lines) {
      if (l.projectId != null) {
        projectId = l.projectId;
        projectName = l.projectName ?? (projectName ?? '');
        break;
      }
    }

    return EditTimesheetFormState(
      timesheetId: t.id,
      timesheetGuid: t.guid,
      employeeId: t.employeeId,
      employeeName: t.employeeName.isNotEmpty ? t.employeeName : null,
      departmentId: t.departmentName.isNotEmpty ? t.departmentName : null,
      projectId: projectId,
      projectName: projectName?.isNotEmpty == true ? projectName : null,
      description: t.description,
      startDate: startDate,
      endDate: endDate,
      weekDays: weekDays,
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      taskTexts: taskTexts,
      lineIds: lineIds,
      taskIds: taskIds,
    );
  }
}

class _EditTimesheetSheetBody extends ConsumerStatefulWidget {
  const _EditTimesheetSheetBody();

  @override
  ConsumerState<_EditTimesheetSheetBody> createState() => _EditTimesheetSheetBodyState();
}

class _EditTimesheetSheetBodyState extends ConsumerState<_EditTimesheetSheetBody> {
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
    final state = ref.watch(editTimesheetProvider);
    final notifier = ref.read(editTimesheetProvider.notifier);
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
                EditTimesheetBasicForm(
                  state: state,
                  notifier: notifier,
                  enterpriseId: enterpriseId,
                  employeeNameController: _employeeNameController,
                  positionController: _positionController,
                  departmentController: _departmentController,
                  descriptionController: _descriptionController,
                ),
                Gap(24.h),
                EditTimesheetTable(
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
          onSaveDraft: _handleSaveDraft,
          onSubmit: _handleSubmitForApproval,
        ),
      ],
    );
  }

  Future<void> _handleSaveDraft() async {
    final notifier = ref.read(editTimesheetProvider.notifier);
    try {
      await notifier.saveDraft();
      if (!mounted) return;
      ToastService.success(context, 'Timesheet saved as draft.');
      Navigator.of(context).pop();
    } on MissingEditTimesheetRequiredDataException {
      if (!mounted) return;
      ToastService.error(context, 'Missing required data to update timesheet.');
    } catch (_) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to update timesheet. Please try again.');
    }
  }

  Future<void> _handleSubmitForApproval() async {
    final notifier = ref.read(editTimesheetProvider.notifier);
    try {
      await notifier.submitForApproval();
      if (!mounted) return;
      ToastService.success(context, 'Timesheet submitted for approval.');
      Navigator.of(context).pop();
    } on MissingEditTimesheetRequiredDataException {
      if (!mounted) return;
      ToastService.error(context, 'Missing required data to update timesheet.');
    } catch (_) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to update timesheet. Please try again.');
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
