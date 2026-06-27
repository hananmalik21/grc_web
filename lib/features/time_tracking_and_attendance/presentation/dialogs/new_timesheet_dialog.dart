import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_basic_form.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_mobile_sheet.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_timesheet_table.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/new_timesheet_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewTimesheetDialog extends ConsumerStatefulWidget {
  const NewTimesheetDialog({super.key});

  static void show(BuildContext context) {
    if (context.isMobile) {
      NewTimesheetMobileSheet.show(context);
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => ProviderScope(
        overrides: [newTimesheetProvider.overrideWith((ref) => NewTimesheetNotifier(ref))],
        child: const NewTimesheetDialog(),
      ),
    );
  }

  @override
  ConsumerState<NewTimesheetDialog> createState() => _NewTimesheetDialogState();
}

class _NewTimesheetDialogState extends ConsumerState<NewTimesheetDialog> {
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
    final state = ref.watch(newTimesheetProvider);
    final notifier = ref.read(newTimesheetProvider.notifier);
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
      title: 'New Weekly Timesheet',
      subtitle: 'Create and submit a weekly timesheet',
      width: 800.w,
      onClose: () => context.pop(),
      content: Form(
        key: _formKey,
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
          onPressed: state.isSavingDraft ? null : () => _handleSubmit(ref, TimesheetStatus.draft),
          type: AppButtonType.outline,
          svgPath: Assets.icons.saveDivisionIcon.path,
          backgroundColor: AppColors.cardBackground,
          foregroundColor: AppColors.primary,
        ),
        Gap(12.w),
        AppButton(
          label: 'Submit for Approval',
          isLoading: state.isSubmittingForApproval,
          onPressed: state.isSubmittingForApproval ? null : () => _handleSubmit(ref, TimesheetStatus.submitted),
          svgPath: Assets.icons.submitted.path,
          type: AppButtonType.primary,
        ),
      ],
    );
  }

  Future<void> _handleSubmit(WidgetRef ref, TimesheetStatus status) async {
    final notifier = ref.read(newTimesheetProvider.notifier);

    try {
      await notifier.submit(status);
      if (!mounted) return;
      ToastService.success(context, 'Timesheet saved successfully.');
      context.pop();
    } on MissingTimesheetRequiredDataException {
      if (!mounted) return;
      ToastService.error(context, 'Missing required data to create timesheet.');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to save timesheet. Please try again.');
    }
  }
}
