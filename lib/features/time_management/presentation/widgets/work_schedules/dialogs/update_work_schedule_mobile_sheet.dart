import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedule_update_notifier.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/create_work_schedule_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/weekly_schedule_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_schedule_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UpdateWorkScheduleMobileSheet extends ConsumerStatefulWidget {
  final int enterpriseId;
  final WorkSchedule schedule;

  const UpdateWorkScheduleMobileSheet({super.key, required this.enterpriseId, required this.schedule});

  static Future<void> show(BuildContext context, int enterpriseId, WorkSchedule schedule) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Update Work Schedule',
      barrierDismissible: false,
      child: UpdateWorkScheduleMobileSheet(enterpriseId: enterpriseId, schedule: schedule),
    );
  }

  @override
  ConsumerState<UpdateWorkScheduleMobileSheet> createState() => _UpdateWorkScheduleMobileSheetState();
}

class _UpdateWorkScheduleMobileSheetState extends ConsumerState<UpdateWorkScheduleMobileSheet> {
  final _scheduleCodeController = TextEditingController();
  final _scheduleNameEnController = TextEditingController();
  final _scheduleNameArController = TextEditingController();

  ({int enterpriseId, int scheduleId}) get _params =>
      (enterpriseId: widget.enterpriseId, scheduleId: widget.schedule.workScheduleId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shiftsState = ref.read(shiftsNotifierProvider(widget.enterpriseId));
      final workPatternsState = ref.read(workPatternsNotifierProvider(widget.enterpriseId));
      final notifier = ref.read(workScheduleUpdateNotifierProvider(_params).notifier);
      notifier.initializeFromSchedule(widget.schedule, shiftsState.items, workPatternsState.items);
      _scheduleCodeController.text = widget.schedule.scheduleCode;
      _scheduleNameEnController.text = widget.schedule.scheduleNameEn;
      _scheduleNameArController.text = widget.schedule.scheduleNameAr;
    });
  }

  @override
  void dispose() {
    _scheduleCodeController.dispose();
    _scheduleNameEnController.dispose();
    _scheduleNameArController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final notifier = ref.read(workScheduleUpdateNotifierProvider(_params).notifier);
    notifier.setScheduleCode(_scheduleCodeController.text);
    notifier.setScheduleNameEn(_scheduleNameEnController.text);
    notifier.setScheduleNameAr(_scheduleNameArController.text);

    final success = await notifier.update();

    if (!mounted) return;

    if (success) {
      context.pop();
      ToastService.success(context, 'Work schedule updated successfully', title: 'Success');
    } else {
      final error = ref.read(workScheduleUpdateNotifierProvider(_params)).error;
      if (error != null) {
        ToastService.error(context, error, title: 'Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final updateState = ref.watch(workScheduleUpdateNotifierProvider(_params));
    final notifier = ref.read(workScheduleUpdateNotifierProvider(_params).notifier);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkScheduleFormFields(
                  scheduleCodeController: _scheduleCodeController,
                  scheduleNameEnController: _scheduleNameEnController,
                  scheduleNameArController: _scheduleNameArController,
                  initialStartDate: widget.schedule.effectiveStartDate,
                  initialEndDate: widget.schedule.effectiveEndDate,
                  selectedWorkPattern: updateState.selectedWorkPattern,
                  selectedTimeZone: updateState.selectedTimeZone,
                  enterpriseId: widget.enterpriseId,
                  selectedStatus: updateState.selectedStatus,
                  isScheduleCodeDisabled: true,
                  onScheduleCodeChanged: notifier.setScheduleCode,
                  onScheduleNameEnChanged: notifier.setScheduleNameEn,
                  onScheduleNameArChanged: notifier.setScheduleNameAr,
                  onWorkPatternChanged: notifier.setSelectedWorkPattern,
                  onStatusChanged: notifier.setSelectedStatus,
                  onTimeZoneChanged: notifier.setSelectedTimeZone,
                  onStartDateSelected: (date) => notifier.setEffectiveStartDate(DateFormat('yyyy-MM-dd').format(date)),
                  onEndDateSelected: (date) => notifier.setEffectiveEndDate(DateFormat('yyyy-MM-dd').format(date)),
                ),
                Gap(24.h),
                WeeklyScheduleSection(
                  isDark: isDark,
                  enterpriseId: widget.enterpriseId,
                  shifts: const [],
                  selectedWorkPattern: updateState.selectedWorkPattern,
                  assignmentMode: updateState.assignmentMode,
                  sameShiftForAllDays: updateState.sameShiftForAllDays,
                  dayShifts: updateState.dayShifts,
                  onAssignmentModeChanged: notifier.setAssignmentMode,
                  onSameShiftChanged: notifier.setSameShiftForAllDays,
                  onDayShiftChanged: notifier.setDayShift,
                ),
              ],
            ),
          ),
        ),
        WorkScheduleSheetFooter(
          cancelLabel: 'Cancel',
          actionLabel: 'Save Changes',
          isLoading: updateState.isUpdating,
          onCancel: updateState.isUpdating ? null : () => context.pop(),
          onAction: updateState.isUpdating ? null : _handleUpdate,
        ),
      ],
    );
  }
}
