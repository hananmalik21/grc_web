import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedule_create_notifier.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/weekly_schedule_section.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/work_schedule_form_fields.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateWorkScheduleMobileSheet extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateWorkScheduleMobileSheet({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Create Work Schedule',
      barrierDismissible: false,
      child: CreateWorkScheduleMobileSheet(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateWorkScheduleMobileSheet> createState() => _CreateWorkScheduleMobileSheetState();
}

class _CreateWorkScheduleMobileSheetState extends ConsumerState<CreateWorkScheduleMobileSheet> {
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

    if (!mounted) return;

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final createState = ref.watch(workScheduleCreateNotifierProvider(widget.enterpriseId));
    final notifier = ref.read(workScheduleCreateNotifierProvider(widget.enterpriseId).notifier);

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
                  initialStartDate: null,
                  initialEndDate: null,
                  selectedWorkPattern: createState.selectedWorkPattern,
                  selectedTimeZone: createState.selectedTimeZone,
                  enterpriseId: widget.enterpriseId,
                  selectedStatus: createState.selectedStatus,
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
                  selectedWorkPattern: createState.selectedWorkPattern,
                  assignmentMode: createState.assignmentMode,
                  sameShiftForAllDays: createState.sameShiftForAllDays,
                  dayShifts: createState.dayShifts,
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
          actionLabel: 'Create Schedule',
          isLoading: createState.isCreating,
          onCancel: createState.isCreating ? null : () => context.pop(),
          onAction: createState.isCreating ? null : _handleCreate,
        ),
      ],
    );
  }
}

class WorkScheduleSheetFooter extends StatelessWidget {
  final String cancelLabel;
  final String actionLabel;
  final bool isLoading;
  final VoidCallback? onCancel;
  final VoidCallback? onAction;

  const WorkScheduleSheetFooter({
    super.key,
    required this.cancelLabel,
    required this.actionLabel,
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
                  svgPath: Assets.icons.saveIcon.path,
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
