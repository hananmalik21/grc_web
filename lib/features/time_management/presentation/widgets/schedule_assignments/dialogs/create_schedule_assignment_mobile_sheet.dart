import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/core/widgets/forms/work_schedule_selection_field.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/features/time_management/presentation/providers/active_org_structure_provider.dart';
import 'package:grc/features/time_management/presentation/providers/create_schedule_assignment_form_provider.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/schedule_assignment_enterprise_structure_fields.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateScheduleAssignmentMobileSheet extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateScheduleAssignmentMobileSheet({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Assign Schedule',
      barrierDismissible: false,
      child: CreateScheduleAssignmentMobileSheet(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateScheduleAssignmentMobileSheet> createState() => _CreateScheduleAssignmentMobileSheetState();
}

class _CreateScheduleAssignmentMobileSheetState extends ConsumerState<CreateScheduleAssignmentMobileSheet> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier).setEnterpriseId(widget.enterpriseId);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleEnterpriseSelection(String levelCode, String? unitId) {
    ref.read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier).setSelectedUnit(levelCode, unitId);
  }

  String? _getLastSelectedOrgUnitId() {
    final orgStructureState = ref.read(scheduleAssignmentActiveOrgStructureProvider(widget.enterpriseId));
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];

    String? lastUnitId;
    for (final level in levels) {
      final formState = ref.read(createScheduleAssignmentFormProvider(widget.enterpriseId));
      final id = formState.selectedUnitIds[level.levelCode];
      if (id != null) lastUnitId = id;
    }
    return lastUnitId;
  }

  Future<void> _handleAssign() async {
    final formState = ref.read(createScheduleAssignmentFormProvider(widget.enterpriseId));
    final orgUnitId = formState.selectedLevel == AssignmentLevel.department ? _getLastSelectedOrgUnitId() : null;
    final employeeId = formState.selectedLevel == AssignmentLevel.employee ? formState.selectedEmployee?.id : null;
    final notifier = ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier);

    final errorMessage = await notifier.submitCreateAssignment(
      assignmentLevel: formState.selectedLevel,
      orgUnitId: orgUnitId,
      employeeId: employeeId,
      workSchedule: formState.selectedWorkSchedule,
      startDate: formState.effectiveStartDate,
      endDate: formState.effectiveEndDate,
      status: formState.selectedStatus,
      notes: _notesController.text,
    );

    if (!mounted) return;

    if (errorMessage != null) {
      ToastService.error(context, errorMessage, title: 'Error');
      return;
    }

    ToastService.success(context, 'Schedule assignment created successfully', title: 'Success');
    if (!mounted) return;
    context.pop();

    await ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(createScheduleAssignmentFormProvider(widget.enterpriseId));
    final formNotifier = ref.read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier);
    final state = ref.watch(scheduleAssignmentsNotifierProvider(widget.enterpriseId));
    final isCreating = state.isCreating;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssignmentLevelSelector(
                  selectedLevel: formState.selectedLevel,
                  onLevelChanged: formNotifier.setAssignmentLevel,
                ),
                Gap(20.h),
                if (formState.selectedLevel == AssignmentLevel.employee)
                  EmployeeSearchField(
                    label: 'Employee',
                    isRequired: true,
                    enterpriseId: widget.enterpriseId,
                    selectedEmployee: formState.selectedEmployee,
                    onEmployeeSelected: formNotifier.setSelectedEmployee,
                  )
                else
                  ScheduleAssignmentEnterpriseStructureFields(
                    localizations: localizations,
                    enterpriseId: widget.enterpriseId,
                    selectedUnitIds: formState.selectedUnitIds,
                    onSelectionChanged: _handleEnterpriseSelection,
                  ),
                Gap(20.h),
                WorkScheduleSelectionField(
                  label: 'Work Schedule',
                  isRequired: true,
                  enterpriseId: widget.enterpriseId,
                  selectedWorkSchedule: formState.selectedWorkSchedule,
                  onChanged: formNotifier.setSelectedWorkSchedule,
                ),
                Gap(20.h),
                _buildDateFields(formState, formNotifier),
                Gap(20.h),
                _buildStatusField(formState, formNotifier),
                Gap(20.h),
                _buildNotesField(),
                Gap(20.h),
                const AssignmentInfoBox(),
              ],
            ),
          ),
        ),
        _ScheduleAssignmentSheetFooter(
          cancelLabel: 'Cancel',
          actionLabel: 'Assign Schedule',
          isLoading: isCreating,
          onCancel: isCreating ? null : () => context.pop(),
          onAction: isCreating ? null : _handleAssign,
        ),
      ],
    );
  }

  Widget _buildDateFields(
    CreateScheduleAssignmentFormState formState,
    CreateScheduleAssignmentFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyDateField(
          label: 'Effective Start Date',
          hintText: 'e.g. 01/01/2025',
          isRequired: true,
          initialDate: formState.effectiveStartDate,
          onDateSelected: formNotifier.setEffectiveStartDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
        Gap(20.h),
        DigifyDateField(
          label: 'Effective End Date',
          hintText: 'e.g. 31/12/2025',
          isRequired: true,
          initialDate: formState.effectiveEndDate,
          onDateSelected: formNotifier.setEffectiveEndDate,
          firstDate: formState.effectiveStartDate ?? DateTime(2000),
          lastDate: DateTime(2100),
          readOnly: formState.effectiveStartDate == null,
        ),
      ],
    );
  }

  Widget _buildStatusField(
    CreateScheduleAssignmentFormState formState,
    CreateScheduleAssignmentFormNotifier formNotifier,
  ) {
    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      isRequired: true,
      hint: 'Select Status',
      items: const ['Active', 'Inactive'],
      itemLabelBuilder: (item) => item,
      value: formState.selectedStatus,
      onChanged: formNotifier.setSelectedStatus,
    );
  }

  Widget _buildNotesField() {
    return DigifyTextField(
      labelText: 'Notes (Optional)',
      controller: _notesController,
      hintText: 'Add any additional notes or comments...',
      maxLines: 3,
      minLines: 3,
    );
  }
}

class _ScheduleAssignmentSheetFooter extends StatelessWidget {
  final String cancelLabel;
  final String actionLabel;
  final bool isLoading;
  final VoidCallback? onCancel;
  final VoidCallback? onAction;

  const _ScheduleAssignmentSheetFooter({
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
