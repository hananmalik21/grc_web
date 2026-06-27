import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeWorkScheduleState {
  final WorkSchedule? selectedWorkSchedule;
  final DateTime? wsStart;
  final DateTime? wsEnd;
  final int? prefillWorkScheduleId;

  const AddEmployeeWorkScheduleState({this.selectedWorkSchedule, this.wsStart, this.wsEnd, this.prefillWorkScheduleId});

  int? get workScheduleId => selectedWorkSchedule?.workScheduleId;

  bool get isStepValid {
    final start = wsStart;
    final end = wsEnd;
    final endValid = end == null || (start != null && !end.isBefore(start));
    return selectedWorkSchedule != null && start != null && endValid;
  }
}

class AddEmployeeWorkScheduleNotifier extends StateNotifier<AddEmployeeWorkScheduleState> {
  AddEmployeeWorkScheduleNotifier() : super(const AddEmployeeWorkScheduleState());

  void setSelectedWorkSchedule(WorkSchedule? value) {
    state = AddEmployeeWorkScheduleState(selectedWorkSchedule: value, wsStart: state.wsStart, wsEnd: state.wsEnd);
  }

  void setWsStart(DateTime? value) {
    state = AddEmployeeWorkScheduleState(
      selectedWorkSchedule: state.selectedWorkSchedule,
      wsStart: value,
      wsEnd: state.wsEnd,
    );
  }

  void setWsEnd(DateTime? value) {
    state = AddEmployeeWorkScheduleState(
      selectedWorkSchedule: state.selectedWorkSchedule,
      wsStart: state.wsStart,
      wsEnd: value,
    );
  }

  void setFromFullDetails({DateTime? wsStart, DateTime? wsEnd, int? workScheduleId}) {
    state = AddEmployeeWorkScheduleState(
      selectedWorkSchedule: state.selectedWorkSchedule,
      wsStart: wsStart ?? state.wsStart,
      wsEnd: wsEnd ?? state.wsEnd,
      prefillWorkScheduleId: workScheduleId ?? state.prefillWorkScheduleId,
    );
  }

  void setSelectedWorkScheduleFromPrefill(WorkSchedule? value) {
    if (value == null) return;
    state = AddEmployeeWorkScheduleState(
      selectedWorkSchedule: value,
      wsStart: state.wsStart,
      wsEnd: state.wsEnd,
      prefillWorkScheduleId: null,
    );
  }

  void reset() {
    state = const AddEmployeeWorkScheduleState();
  }
}

final addEmployeeWorkScheduleProvider =
    StateNotifierProvider<AddEmployeeWorkScheduleNotifier, AddEmployeeWorkScheduleState>((ref) {
      return AddEmployeeWorkScheduleNotifier();
    });
