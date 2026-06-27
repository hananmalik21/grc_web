import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
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
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/active_org_structure_provider.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_info_box.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/assignment_level_selector.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/schedule_assignment_enterprise_structure_fields_edit.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditScheduleAssignmentMobileSheet extends ConsumerStatefulWidget {
  final int enterpriseId;
  final ScheduleAssignment assignment;

  const EditScheduleAssignmentMobileSheet({super.key, required this.enterpriseId, required this.assignment});

  static Future<void> show(BuildContext context, int enterpriseId, ScheduleAssignment assignment) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: 'Edit Schedule Assignment',
      barrierDismissible: false,
      child: EditScheduleAssignmentMobileSheet(enterpriseId: enterpriseId, assignment: assignment),
    );
  }

  @override
  ConsumerState<EditScheduleAssignmentMobileSheet> createState() => _EditScheduleAssignmentMobileSheetState();
}

class _EditScheduleAssignmentMobileSheetState extends ConsumerState<EditScheduleAssignmentMobileSheet> {
  late AssignmentLevel _selectedLevel;
  WorkSchedule? _selectedWorkSchedule;
  late String _selectedStatus;
  final Map<String, String?> _selectedUnitIds = {};
  Map<String, OrgUnit>? _initialSelections;
  DateTime? _effectiveStartDate;
  DateTime? _effectiveEndDate;
  Employee? _selectedEmployee;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
    _initializeEnterpriseStructureFromOrgPath();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier).setEnterpriseId(widget.enterpriseId);
      _initializeWorkSchedule();
    });
  }

  void _initializeFormFields() {
    final a = widget.assignment;
    _selectedLevel = a.assignmentLevel;
    _effectiveStartDate = a.effectiveStartDate;
    _effectiveEndDate = a.effectiveEndDate;
    _selectedStatus = _convertStatus(a.status);
    _notesController = TextEditingController(text: a.notes ?? '');

    if (_selectedLevel == AssignmentLevel.employee && a.employee != null) {
      final emp = a.employee!;
      _selectedEmployee = Employee(
        id: a.employeeId ?? 0,
        guid: '',
        enterpriseId: widget.enterpriseId,
        firstName: emp.name.split(' ').first,
        lastName: emp.name.split(' ').length > 1 ? emp.name.split(' ').sublist(1).join(' ') : '',
        email: '',
        status: 'ACTIVE',
        isActive: true,
        createdAt: DateTime.now(),
      );
    }

    if (a.workSchedule != null) {
      final ws = a.workSchedule!;
      _selectedWorkSchedule = WorkSchedule(
        workScheduleId: ws.workScheduleId,
        tenantId: widget.enterpriseId,
        scheduleCode: ws.scheduleCode,
        scheduleNameEn: ws.scheduleNameEn,
        scheduleNameAr: ws.scheduleNameAr,
        workPatternId: 0,
        effectiveStartDate: a.effectiveStartDate,
        assignmentMode: 'FIXED',
        status: PositionStatus.active,
        creationDate: DateTime.now(),
        createdBy: 'SYSTEM',
        lastUpdateDate: DateTime.now(),
        lastUpdatedBy: 'ADMIN',
        weeklyLines: const [],
      );
    }
  }

  void _initializeWorkSchedule() {
    final workSchedulesState = ref.read(workSchedulesNotifierProvider(widget.enterpriseId));
    try {
      final workSchedule = workSchedulesState.items.firstWhere(
        (s) => s.workScheduleId == widget.assignment.workScheduleId,
      );
      if (mounted) setState(() => _selectedWorkSchedule = workSchedule);
    } catch (_) {}
  }

  void _initializeEnterpriseStructureFromOrgPath() {
    final a = widget.assignment;
    if (a.orgPath == null || a.orgPath!.isEmpty) return;
    final structureId = a.orgStructure?.id ?? a.orgUnit?.orgStructureId;
    if (structureId == null || structureId.isEmpty) return;

    final selections = <String, OrgUnit>{};
    for (int i = 0; i < a.orgPath!.length; i++) {
      final p = a.orgPath![i];
      _selectedUnitIds[p.levelCode] = p.orgUnitId;
      selections[p.levelCode] = OrgUnit(
        orgUnitId: p.orgUnitId,
        orgStructureId: structureId,
        enterpriseId: widget.enterpriseId,
        levelCode: p.levelCode,
        orgUnitCode: p.orgUnitId,
        orgUnitNameEn: p.nameEn,
        orgUnitNameAr: p.nameAr,
        parentOrgUnitId: i > 0 ? a.orgPath![i - 1].orgUnitId : null,
        isActive: true,
      );
    }
    _initialSelections = selections;
  }

  String _convertStatus(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'Active';
      case 'PENDING':
        return 'Pending';
      case 'INACTIVE':
        return 'Inactive';
      default:
        return status;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _handleEnterpriseSelection(String levelCode, String? unitId) {
    setState(() => _selectedUnitIds[levelCode] = unitId);
  }

  String? _getLastSelectedOrgUnitId() {
    final orgStructureState = ref.read(scheduleAssignmentActiveOrgStructureProvider(widget.enterpriseId));
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];

    String? lastUnitId;
    for (final level in levels) {
      final id = _selectedUnitIds[level.levelCode];
      if (id != null) lastUnitId = id;
    }
    return lastUnitId;
  }

  Future<void> _handleUpdate() async {
    final orgUnitId = _selectedLevel == AssignmentLevel.department ? _getLastSelectedOrgUnitId() : null;
    final employeeId = _selectedLevel == AssignmentLevel.employee ? _selectedEmployee?.id : null;
    final notifier = ref.read(scheduleAssignmentsNotifierProvider(widget.enterpriseId).notifier);

    final errorMessage = await notifier.submitUpdateAssignment(
      scheduleAssignmentId: widget.assignment.scheduleAssignmentId,
      assignmentLevel: _selectedLevel,
      orgUnitId: orgUnitId,
      employeeId: employeeId,
      workSchedule: _selectedWorkSchedule,
      startDate: _effectiveStartDate,
      endDate: _effectiveEndDate,
      status: _selectedStatus,
      notes: _notesController.text,
    );

    if (!mounted) return;

    if (errorMessage != null) {
      ToastService.error(context, errorMessage, title: 'Error');
      return;
    }

    ToastService.success(context, 'Schedule assignment updated successfully', title: 'Success');
    if (!mounted) return;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(scheduleAssignmentsNotifierProvider(widget.enterpriseId));
    final isUpdating = state.isCreating;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AssignmentLevelSelector(
                  selectedLevel: _selectedLevel,
                  onLevelChanged: (level) {
                    setState(() {
                      _selectedLevel = level;
                      if (level == AssignmentLevel.employee) {
                        _selectedUnitIds.clear();
                      } else {
                        _selectedEmployee = null;
                      }
                    });
                  },
                ),
                Gap(20.h),
                if (_selectedLevel == AssignmentLevel.employee)
                  EmployeeSearchField(
                    label: 'Employee',
                    isRequired: true,
                    enterpriseId: widget.enterpriseId,
                    selectedEmployee: _selectedEmployee,
                    onEmployeeSelected: (employee) {
                      setState(() => _selectedEmployee = employee);
                    },
                  )
                else
                  ScheduleAssignmentEnterpriseStructureFieldsEdit(
                    localizations: localizations,
                    enterpriseId: widget.enterpriseId,
                    selectedUnitIds: _selectedUnitIds,
                    initialSelections: _initialSelections,
                    onSelectionChanged: _handleEnterpriseSelection,
                  ),
                Gap(20.h),
                WorkScheduleSelectionField(
                  label: 'Work Schedule',
                  isRequired: true,
                  enterpriseId: widget.enterpriseId,
                  selectedWorkSchedule: _selectedWorkSchedule,
                  onChanged: (schedule) {
                    setState(() => _selectedWorkSchedule = schedule);
                  },
                ),
                Gap(20.h),
                _buildDateFields(),
                Gap(20.h),
                _buildStatusField(),
                Gap(20.h),
                _buildNotesField(),
                Gap(20.h),
                const AssignmentInfoBox(),
              ],
            ),
          ),
        ),
        _EditSheetFooter(
          isLoading: isUpdating,
          onCancel: isUpdating ? null : () => context.pop(),
          onAction: isUpdating ? null : _handleUpdate,
        ),
      ],
    );
  }

  Widget _buildDateFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyDateField(
          label: 'Effective Start Date',
          isRequired: true,
          initialDate: _effectiveStartDate,
          onDateSelected: (date) {
            setState(() {
              _effectiveStartDate = date;
              if (_effectiveEndDate != null && _effectiveEndDate!.isBefore(date)) {
                _effectiveEndDate = null;
              }
            });
          },
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ),
        Gap(20.h),
        DigifyDateField(
          label: 'Effective End Date',
          isRequired: true,
          initialDate: _effectiveEndDate,
          onDateSelected: (date) => setState(() => _effectiveEndDate = date),
          firstDate: _effectiveStartDate ?? DateTime(2000),
          lastDate: DateTime(2100),
          readOnly: _effectiveStartDate == null,
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      isRequired: true,
      hint: 'Select Status',
      items: const ['Active', 'Inactive'],
      itemLabelBuilder: (item) => item,
      value: _selectedStatus,
      onChanged: (value) => setState(() => _selectedStatus = value ?? ''),
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

class _EditSheetFooter extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onCancel;
  final VoidCallback? onAction;

  const _EditSheetFooter({required this.isLoading, required this.onCancel, required this.onAction});

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
              AppButton.outline(label: 'Cancel', onPressed: onCancel, height: 46),
              Gap(10.w),
              Expanded(
                child: AppButton(
                  label: 'Save Changes',
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
