import 'package:grc/features/time_management/domain/models/assignment_level.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateScheduleAssignmentFormState {
  const CreateScheduleAssignmentFormState({
    this.selectedLevel = AssignmentLevel.department,
    this.selectedWorkSchedule,
    this.selectedStatus = 'Active',
    this.selectedUnitIds = const {},
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.selectedEmployee,
  });

  final AssignmentLevel selectedLevel;
  final WorkSchedule? selectedWorkSchedule;
  final String selectedStatus;
  final Map<String, String?> selectedUnitIds;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final Employee? selectedEmployee;

  CreateScheduleAssignmentFormState copyWith({
    AssignmentLevel? selectedLevel,
    WorkSchedule? selectedWorkSchedule,
    bool clearSelectedWorkSchedule = false,
    String? selectedStatus,
    Map<String, String?>? selectedUnitIds,
    DateTime? effectiveStartDate,
    bool clearEffectiveStartDate = false,
    DateTime? effectiveEndDate,
    bool clearEffectiveEndDate = false,
    Employee? selectedEmployee,
    bool clearSelectedEmployee = false,
  }) {
    return CreateScheduleAssignmentFormState(
      selectedLevel: selectedLevel ?? this.selectedLevel,
      selectedWorkSchedule:
          clearSelectedWorkSchedule ? null : (selectedWorkSchedule ?? this.selectedWorkSchedule),
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedUnitIds: selectedUnitIds ?? this.selectedUnitIds,
      effectiveStartDate:
          clearEffectiveStartDate ? null : (effectiveStartDate ?? this.effectiveStartDate),
      effectiveEndDate:
          clearEffectiveEndDate ? null : (effectiveEndDate ?? this.effectiveEndDate),
      selectedEmployee:
          clearSelectedEmployee ? null : (selectedEmployee ?? this.selectedEmployee),
    );
  }
}

class CreateScheduleAssignmentFormNotifier
    extends StateNotifier<CreateScheduleAssignmentFormState> {
  CreateScheduleAssignmentFormNotifier() : super(const CreateScheduleAssignmentFormState());

  void setAssignmentLevel(AssignmentLevel level) {
    state = state.copyWith(
      selectedLevel: level,
      selectedUnitIds: level == AssignmentLevel.employee ? const {} : state.selectedUnitIds,
      clearSelectedEmployee: level == AssignmentLevel.department,
    );
  }

  void setSelectedEmployee(Employee? employee) {
    state = state.copyWith(selectedEmployee: employee);
  }

  void setSelectedUnit(String levelCode, String? unitId) {
    final updated = Map<String, String?>.from(state.selectedUnitIds);
    updated[levelCode] = unitId;
    state = state.copyWith(selectedUnitIds: updated);
  }

  void setSelectedWorkSchedule(WorkSchedule? workSchedule) {
    state = state.copyWith(selectedWorkSchedule: workSchedule);
  }

  void setEffectiveStartDate(DateTime date) {
    final shouldClearEnd =
        state.effectiveEndDate != null && state.effectiveEndDate!.isBefore(date);
    state = state.copyWith(effectiveStartDate: date, clearEffectiveEndDate: shouldClearEnd);
  }

  void setEffectiveEndDate(DateTime date) {
    state = state.copyWith(effectiveEndDate: date);
  }

  void setSelectedStatus(String? status) {
    if (status == null) return;
    state = state.copyWith(selectedStatus: status);
  }
}

final createScheduleAssignmentFormProvider = StateNotifierProvider.autoDispose
    .family<CreateScheduleAssignmentFormNotifier, CreateScheduleAssignmentFormState, int>(
      (_, _) => CreateScheduleAssignmentFormNotifier(),
    );
