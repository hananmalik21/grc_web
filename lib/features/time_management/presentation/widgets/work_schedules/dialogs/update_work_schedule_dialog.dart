import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedule_update_notifier.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/update_work_schedule_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/weekly_schedule_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_schedule_form_fields.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class UpdateWorkScheduleDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final WorkSchedule schedule;

  const UpdateWorkScheduleDialog({super.key, required this.enterpriseId, required this.schedule});

  static Future<void> show(BuildContext context, int enterpriseId, WorkSchedule schedule) {
    if (ResponsiveHelper.isMobile(context)) {
      return UpdateWorkScheduleMobileSheet.show(context, enterpriseId, schedule);
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateWorkScheduleDialog(enterpriseId: enterpriseId, schedule: schedule),
    );
  }

  @override
  ConsumerState<UpdateWorkScheduleDialog> createState() => _UpdateWorkScheduleDialogState();
}

class _UpdateWorkScheduleDialogState extends ConsumerState<UpdateWorkScheduleDialog> {
  final _scheduleCodeController = TextEditingController();
  final _scheduleNameEnController = TextEditingController();
  final _scheduleNameArController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final shiftsState = ref.read(shiftsNotifierProvider(widget.enterpriseId));
        final workPatternsState = ref.read(workPatternsNotifierProvider(widget.enterpriseId));
        final notifier = ref.read(
          workScheduleUpdateNotifierProvider((
            enterpriseId: widget.enterpriseId,
            scheduleId: widget.schedule.workScheduleId,
          )).notifier,
        );
        notifier.initializeFromSchedule(widget.schedule, shiftsState.items, workPatternsState.items);
        _scheduleCodeController.text = widget.schedule.scheduleCode;
        _scheduleNameEnController.text = widget.schedule.scheduleNameEn;
        _scheduleNameArController.text = widget.schedule.scheduleNameAr;
      }
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
    final notifier = ref.read(
      workScheduleUpdateNotifierProvider((
        enterpriseId: widget.enterpriseId,
        scheduleId: widget.schedule.workScheduleId,
      )).notifier,
    );
    notifier.setScheduleCode(_scheduleCodeController.text);
    notifier.setScheduleNameEn(_scheduleNameEnController.text);
    notifier.setScheduleNameAr(_scheduleNameArController.text);

    final success = await notifier.update();

    if (mounted) {
      if (success) {
        context.pop();
        ToastService.success(context, 'Work schedule updated successfully', title: 'Success');
      } else {
        final error = ref
            .read(
              workScheduleUpdateNotifierProvider((
                enterpriseId: widget.enterpriseId,
                scheduleId: widget.schedule.workScheduleId,
              )),
            )
            .error;
        if (error != null) {
          ToastService.error(context, error, title: 'Error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final updateState = ref.watch(
      workScheduleUpdateNotifierProvider((
        enterpriseId: widget.enterpriseId,
        scheduleId: widget.schedule.workScheduleId,
      )),
    );

    final notifier = ref.read(
      workScheduleUpdateNotifierProvider((
        enterpriseId: widget.enterpriseId,
        scheduleId: widget.schedule.workScheduleId,
      )).notifier,
    );

    return AppDialog(
      title: 'Update Work Schedule',
      width: 1024.w,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              onScheduleCodeChanged: (value) {
                notifier.setScheduleCode(value);
              },
              onScheduleNameEnChanged: (value) {
                notifier.setScheduleNameEn(value);
              },
              onScheduleNameArChanged: (value) {
                notifier.setScheduleNameAr(value);
              },
              onWorkPatternChanged: (value) {
                notifier.setSelectedWorkPattern(value);
              },
              onStatusChanged: (value) {
                notifier.setSelectedStatus(value);
              },
              onTimeZoneChanged: (value) {
                notifier.setSelectedTimeZone(value);
              },
              onStartDateSelected: (date) {
                notifier.setEffectiveStartDate(DateFormat('yyyy-MM-dd').format(date));
              },
              onEndDateSelected: (date) {
                notifier.setEffectiveEndDate(DateFormat('yyyy-MM-dd').format(date));
              },
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
              onSameShiftChanged: (value) {
                notifier.setSameShiftForAllDays(value);
              },
              onDayShiftChanged: (dayOfWeek, shift) {
                notifier.setDayShift(dayOfWeek, shift);
              },
            ),
          ],
        ),
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: updateState.isUpdating ? null : () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Save Changes',
          onPressed: updateState.isUpdating ? null : _handleUpdate,
          isLoading: updateState.isUpdating,
          svgPath: Assets.icons.saveIcon.path,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
