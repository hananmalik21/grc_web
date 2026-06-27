import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedule_create_notifier.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/create_work_schedule_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/weekly_schedule_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_schedule_form_fields.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateWorkScheduleDialog extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateWorkScheduleDialog({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    if (ResponsiveHelper.isMobile(context)) {
      return CreateWorkScheduleMobileSheet.show(context, enterpriseId);
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateWorkScheduleDialog(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateWorkScheduleDialog> createState() => _CreateWorkScheduleDialogState();
}

class _CreateWorkScheduleDialogState extends ConsumerState<CreateWorkScheduleDialog> {
  final _scheduleCodeController = TextEditingController();
  final _scheduleNameEnController = TextEditingController();
  final _scheduleNameArController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier).reset();
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

  Future<void> _handleCreate() async {
    final notifier = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier);
    notifier.setScheduleCode(_scheduleCodeController.text);
    notifier.setScheduleNameEn(_scheduleNameEnController.text);
    notifier.setScheduleNameAr(_scheduleNameArController.text);

    final success = await notifier.create();

    if (mounted) {
      if (success) {
        context.pop();
        ToastService.success(context, 'Work schedule created successfully', title: 'Success');
      } else {
        final error = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId)).error;
        if (error != null) {
          ToastService.error(context, error, title: 'Error');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final createState = ref.watch(workScheduleCreateNotifierProvider(widget.enterpriseId));

    final notifier = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier);

    return AppDialog(
      title: 'Create Work Schedule',
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
              initialStartDate: null,
              initialEndDate: null,
              selectedWorkPattern: createState.selectedWorkPattern,
              selectedTimeZone: createState.selectedTimeZone,
              enterpriseId: widget.enterpriseId,
              selectedStatus: createState.selectedStatus,
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
              selectedWorkPattern: createState.selectedWorkPattern,
              assignmentMode: createState.assignmentMode,
              sameShiftForAllDays: createState.sameShiftForAllDays,
              dayShifts: createState.dayShifts,
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
        AppButton.outline(label: 'Cancel', onPressed: createState.isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Save Changes',
          onPressed: createState.isCreating ? null : _handleCreate,
          isLoading: createState.isCreating,
          svgPath: Assets.icons.saveIcon.path,
          backgroundColor: AppColors.primary,
        ),
      ],
    );
  }
}
