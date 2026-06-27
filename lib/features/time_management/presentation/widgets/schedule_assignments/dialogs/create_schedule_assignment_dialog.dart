import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/create_schedule_assignment_mobile_sheet.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/create_schedule_assignment_form_provider.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/schedule_assignment_enterprise_structure_fields.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/time_management/presentation/providers/active_org_structure_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateScheduleAssignmentDialog extends ConsumerStatefulWidget {
  final int enterpriseId;

  const CreateScheduleAssignmentDialog({super.key, required this.enterpriseId});

  static Future<void> show(BuildContext context, int enterpriseId) {
    if (ResponsiveHelper.isMobile(context)) {
      return CreateScheduleAssignmentMobileSheet.show(context, enterpriseId);
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateScheduleAssignmentDialog(enterpriseId: enterpriseId),
    );
  }

  @override
  ConsumerState<CreateScheduleAssignmentDialog> createState() => _CreateScheduleAssignmentDialogState();
}

class _CreateScheduleAssignmentDialogState extends ConsumerState<CreateScheduleAssignmentDialog> {
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier).setEnterpriseId(widget.enterpriseId);
      ref.read(workSchedulesNotifierProvider(widget.enterpriseId).notifier).setEnterpriseId(widget.enterpriseId);
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
      final selectedUnitIds = ref.read(createScheduleAssignmentFormProvider(widget.enterpriseId));
      final id = selectedUnitIds.selectedUnitIds[level.levelCode];
      if (id != null) {
        lastUnitId = id;
      }
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

    if (!mounted) return;

    ToastService.success(context, 'Schedule assignment created successfully', title: 'Success');
    if (!mounted) return;
    context.pop();

    await ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final scheduleAssignmentsState = ref.watch(scheduleAssignmentsNotifierProvider(widget.enterpriseId));
    final workSchedulesState = ref.watch(workSchedulesNotifierProvider(widget.enterpriseId));
    final formState = ref.watch(createScheduleAssignmentFormProvider(widget.enterpriseId));
    final isCreating = scheduleAssignmentsState.isCreating;

    return AppDialog(
      title: 'Assign Schedule',
      width: 768.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AssignmentLevelSelector(
            selectedLevel: formState.selectedLevel,
            onLevelChanged: ref
                .read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier)
                .setAssignmentLevel,
          ),
          Gap(24.h),
          if (formState.selectedLevel == AssignmentLevel.employee)
            Builder(
              builder: (context) {
                return EmployeeSearchField(
                  label: 'Employee',
                  isRequired: true,
                  enterpriseId: widget.enterpriseId,
                  selectedEmployee: formState.selectedEmployee,
                  onEmployeeSelected: ref
                      .read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier)
                      .setSelectedEmployee,
                );
              },
            )
          else
            ScheduleAssignmentEnterpriseStructureFields(
              localizations: localizations,
              enterpriseId: widget.enterpriseId,
              selectedUnitIds: formState.selectedUnitIds,
              onSelectionChanged: _handleEnterpriseSelection,
            ),
          Gap(24.h),
          DigifySelectionFieldWithLabel(
            label: 'Work Schedule',
            isRequired: true,
            hint: 'Select Work Schedule',
            value: formState.selectedWorkSchedule?.scheduleNameEn,
            onTap: () async {
              final scheduleNotifier = ref.read(workSchedulesNotifierProvider(widget.enterpriseId).notifier);
              scheduleNotifier.setEnterpriseId(widget.enterpriseId);
              if (workSchedulesState.items.isEmpty && !workSchedulesState.isLoading) {
                await scheduleNotifier.loadFirstPage();
              }
              if (!context.mounted) return;
              final latestState = ref.read(workSchedulesNotifierProvider(widget.enterpriseId));
              final selected = await DigifySingleSelectDialog.show<WorkSchedule>(
                context: context,
                title: 'Select Work Schedule',
                subtitle: 'Choose a work schedule from the list',
                items: latestState.items,
                selectedId: formState.selectedWorkSchedule?.workScheduleId.toString(),
                idBuilder: (schedule) => schedule.workScheduleId.toString(),
                labelBuilder: (schedule) => schedule.scheduleNameEn,
                descriptionBuilder: (schedule) => schedule.scheduleCode,
                searchHint: 'Search work schedules...',
                emptyMessage: 'No Work Schedules found',
                isLoading: latestState.isLoading,
                errorMessage: latestState.errorMessage,
                onRetry: scheduleNotifier.refresh,
                pagination: DigifySingleSelectPagination(
                  currentPage: latestState.currentPage,
                  totalPages: latestState.totalPages,
                  totalItems: latestState.totalItems,
                  pageSize: latestState.pageSize,
                  hasNext: latestState.hasNextPage,
                  hasPrevious: latestState.hasPreviousPage,
                ),
                onPreviousPage: latestState.hasPreviousPage
                    ? () => scheduleNotifier.goToPage(latestState.currentPage - 1)
                    : null,
                onNextPage: latestState.hasNextPage
                    ? () => scheduleNotifier.goToPage(latestState.currentPage + 1)
                    : null,
              );
              if (selected != null) {
                ref
                    .read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier)
                    .setSelectedWorkSchedule(selected);
              }
            },
          ),
          Gap(24.h),
          _buildDateFields(formState),
          Gap(24.h),
          _buildStatusField(formState),
          Gap(24.h),
          _buildNotesField(),
          Gap(24.h),
          const AssignmentInfoBox(),
        ],
      ),
      actions: [
        AppButton(label: 'Cancel', type: AppButtonType.outline, onPressed: isCreating ? null : () => context.pop()),
        Gap(12.w),
        AppButton(
          label: 'Assign Schedule',
          type: AppButtonType.primary,
          onPressed: isCreating ? null : _handleAssign,
          svgPath: Assets.icons.saveIcon.path,
          isLoading: isCreating,
        ),
      ],
    );
  }

  Widget _buildDateFields(CreateScheduleAssignmentFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyDateField(
          label: 'Effective Start Date',
          hintText: 'e.g. 01/01/2025',
          isRequired: true,
          initialDate: formState.effectiveStartDate,
          onDateSelected: ref
              .read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier)
              .setEffectiveStartDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
        Gap(24.h),
        DigifyDateField(
          label: 'Effective End Date',
          hintText: 'e.g. 31/12/2025',
          isRequired: true,
          initialDate: formState.effectiveEndDate,
          onDateSelected: ref
              .read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier)
              .setEffectiveEndDate,
          firstDate: formState.effectiveStartDate ?? DateTime(2000),
          lastDate: DateTime(2100),
          readOnly: formState.effectiveStartDate == null,
        ),
      ],
    );
  }

  Widget _buildStatusField(CreateScheduleAssignmentFormState formState) {
    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      isRequired: true,
      hint: 'Select Status',
      items: const ['Active', 'Inactive'],
      itemLabelBuilder: (item) => item,
      value: formState.selectedStatus,
      onChanged: ref.read(createScheduleAssignmentFormProvider(widget.enterpriseId).notifier).setSelectedStatus,
    );
  }

  Widget _buildNotesField() {
    return DigifyTextField(
      labelText: 'Notes (Optional)',
      controller: _notesController,
      hintText: 'Add any additional notes or comments...',
      maxLines: 4,
      minLines: 4,
    );
  }
}
