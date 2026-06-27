import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_basic_form.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_mobile_sheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_timesheet_table.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/edit_timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditTimesheetDialog extends ConsumerStatefulWidget {
  const EditTimesheetDialog({super.key, required this.timesheet});

  final Timesheet timesheet;

  static void show(BuildContext context, Timesheet timesheet) {
    if (context.isMobile) {
      EditTimesheetMobileSheet.show(context, timesheet);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ProviderScope(
        overrides: [
          editTimesheetProvider.overrideWith((ref) {
            final initial = _initialStateFromTimesheet(timesheet);
            return EditTimesheetNotifier(ref, initial);
          }),
        ],
        child: EditTimesheetDialog(timesheet: timesheet),
      ),
    );
  }

  static EditTimesheetFormState _initialStateFromTimesheet(Timesheet t) {
    final startDate = t.weekStartDate;
    final endDate = t.weekEndDate;
    final weekDays = List.generate(7, (i) => startDate.add(Duration(days: i)));
    String dateKey(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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

  @override
  ConsumerState<EditTimesheetDialog> createState() => _EditTimesheetDialogState();
}

class _EditTimesheetDialogState extends ConsumerState<EditTimesheetDialog> {
  final _formKey = GlobalKey<FormState>();
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
    final ref = this.ref;
    final state = ref.watch(editTimesheetProvider);
    final notifier = ref.read(editTimesheetProvider.notifier);
    final enterpriseId = ref.watch(timesheetEnterpriseIdProvider);

    _employeeNameController.text = state.employeeName ?? '';
    _positionController.text = state.position ?? '';
    _departmentController.text = state.departmentId ?? '';
    _descriptionController.text = state.description ?? '';

    for (var i = 0; i < state.weekDays.length && i < 7; i++) {
      final regular = (i < state.regularHours.length) ? state.regularHours[i] : 0.0;
      final overtime = (i < state.overtimeHours.length) ? state.overtimeHours[i] : 0.0;
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

    return AppDialog(
      title: 'Edit Timesheet',
      subtitle: 'Update your draft timesheet',
      width: 800.w,
      onClose: () => context.pop(),
      content: Form(
        key: _formKey,
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
          label: 'Save as Draft',
          isLoading: state.isSavingDraft,
          onPressed: (state.isSavingDraft || state.isSubmittingForApproval) ? null : () => _handleSaveDraft(ref),
          type: AppButtonType.outline,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.primary,
          svgPath: Assets.icons.saveDivisionIcon.path,
        ),
        Gap(12.w),
        AppButton(
          label: 'Submit for Approval',
          isLoading: state.isSubmittingForApproval,
          onPressed: (state.isSavingDraft || state.isSubmittingForApproval)
              ? null
              : () => _handleSubmitForApproval(ref),
          type: AppButtonType.primary,
          svgPath: Assets.icons.submitted.path,
        ),
      ],
    );
  }

  Future<void> _handleSaveDraft(WidgetRef ref) async {
    final notifier = ref.read(editTimesheetProvider.notifier);
    try {
      await notifier.saveDraft();
      if (!mounted) return;
      ToastService.success(context, 'Timesheet saved as draft.');
      context.pop();
    } on MissingEditTimesheetRequiredDataException {
      if (!mounted) return;
      ToastService.error(context, 'Missing required data to update timesheet.');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to update timesheet. Please try again.');
    }
  }

  Future<void> _handleSubmitForApproval(WidgetRef ref) async {
    final notifier = ref.read(editTimesheetProvider.notifier);
    try {
      await notifier.submitForApproval();
      if (!mounted) return;
      ToastService.success(context, 'Timesheet submitted for approval.');
      context.pop();
    } on MissingEditTimesheetRequiredDataException {
      if (!mounted) return;
      ToastService.error(context, 'Missing required data to update timesheet.');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to update timesheet. Please try again.');
    }
  }
}
