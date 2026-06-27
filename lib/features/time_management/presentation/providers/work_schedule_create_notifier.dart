import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/models/time_zone.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/usecases/create_work_schedule_usecase.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedule_create_state.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkScheduleCreateNotifier extends StateNotifier<WorkScheduleCreateState> {
  final CreateWorkScheduleUseCase createUseCase;
  final int enterpriseId;
  final WorkSchedulesNotifier workSchedulesNotifier;

  WorkScheduleCreateNotifier({
    required this.createUseCase,
    required this.enterpriseId,
    required this.workSchedulesNotifier,
  }) : super(const WorkScheduleCreateState());

  void setScheduleCode(String value) {
    state = state.copyWith(scheduleCode: value);
  }

  void setScheduleNameEn(String value) {
    state = state.copyWith(scheduleNameEn: value);
  }

  void setScheduleNameAr(String value) {
    state = state.copyWith(scheduleNameAr: value);
  }

  void setEffectiveStartDate(String value) {
    state = state.copyWith(effectiveStartDate: value);
  }

  void setEffectiveEndDate(String value) {
    state = state.copyWith(effectiveEndDate: value);
  }

  void setSelectedWorkPattern(WorkPattern? value) {
    final newDayShifts = <int, ShiftOverview?>{};
    if (value != null) {
      for (final day in value.days) {
        if (day.dayType == 'WORK') {
          final existingShift = state.dayShifts[day.dayOfWeek];
          if (existingShift != null) {
            newDayShifts[day.dayOfWeek] = existingShift;
          }
        }
      }
    }
    state = state.copyWith(selectedWorkPattern: value, dayShifts: value == null ? {} : newDayShifts);
  }

  void setSelectedStatus(PositionStatus value) {
    state = state.copyWith(selectedStatus: value);
  }

  void setSelectedTimeZone(TimeZone? value) {
    state = state.copyWith(selectedTimeZone: value, clearTimeZone: value == null);
  }

  void setAssignmentMode(WorkScheduleAssignmentMode value) {
    if (value == state.assignmentMode) return;

    if (value == WorkScheduleAssignmentMode.sameShiftAllDays) {
      state = state.copyWith(assignmentMode: value, dayShifts: {});
    } else {
      state = state.copyWith(assignmentMode: value, clearSameShift: true);
    }
  }

  void setSameShiftForAllDays(ShiftOverview? value) {
    state = state.copyWith(sameShiftForAllDays: value);
  }

  void setDayShift(int dayOfWeek, ShiftOverview? shift) {
    final updatedDayShifts = Map<int, ShiftOverview?>.from(state.dayShifts);
    if (shift == null) {
      updatedDayShifts.remove(dayOfWeek);
    } else {
      updatedDayShifts[dayOfWeek] = shift;
    }
    state = state.copyWith(dayShifts: updatedDayShifts);
  }

  bool validate() {
    if (state.scheduleCode.trim().isEmpty) {
      state = state.copyWith(error: 'Schedule code is required');
      return false;
    }

    if (state.scheduleNameEn.trim().isEmpty) {
      state = state.copyWith(error: 'Schedule name (English) is required');
      return false;
    }

    if (state.selectedWorkPattern == null) {
      state = state.copyWith(error: 'Please select a work pattern');
      return false;
    }

    if (state.selectedTimeZone == null) {
      state = state.copyWith(error: 'Time zone is required');
      return false;
    }

    if (state.effectiveStartDate.trim().isEmpty) {
      state = state.copyWith(error: 'Effective start date is required');
      return false;
    }

    if (state.assignmentMode == WorkScheduleAssignmentMode.sameShiftAllDays) {
      if (state.sameShiftForAllDays == null) {
        state = state.copyWith(error: 'Please select a shift for all days');
        return false;
      }
    } else {
      final hasAtLeastOneShift = state.dayShifts.values.any((shift) => shift != null);
      if (!hasAtLeastOneShift) {
        state = state.copyWith(error: 'Please select at least one shift for a day');
        return false;
      }
    }

    state = state.copyWith(clearError: true);
    return true;
  }

  Future<bool> create() async {
    if (!validate()) {
      return false;
    }

    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final weeklyLines = <Map<String, dynamic>>[];

      if (state.assignmentMode == WorkScheduleAssignmentMode.sameShiftAllDays) {
        final pattern = state.selectedWorkPattern!;
        for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
          final patternDay = pattern.days.firstWhere(
            (d) => d.dayOfWeek == dayOfWeek,
            orElse: () => WorkPatternDay(dayOfWeek: dayOfWeek, dayType: 'REST'),
          );

          if (patternDay.dayType == 'WORK') {
            weeklyLines.add({'day_of_week': dayOfWeek, 'day_type': 'WORK', 'shift_id': state.sameShiftForAllDays!.id});
          } else {
            weeklyLines.add({'day_of_week': dayOfWeek, 'day_type': patternDay.dayType});
          }
        }
      } else {
        for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
          final shift = state.dayShifts[dayOfWeek];
          if (shift != null) {
            weeklyLines.add({'day_of_week': dayOfWeek, 'day_type': 'WORK', 'shift_id': shift.id});
          } else {
            weeklyLines.add({'day_of_week': dayOfWeek, 'day_type': 'REST'});
          }
        }
      }

      final requestData = {
        'tenant_id': enterpriseId,
        'schedule_code': state.scheduleCode.trim(),
        'schedule_name_en': state.scheduleNameEn.trim(),
        'schedule_name_ar': state.scheduleNameAr.trim(),
        if (state.selectedTimeZone != null) 'time_zone': state.selectedTimeZone!.tzName,
        'work_pattern_id': state.selectedWorkPattern!.workPatternId,
        'effective_start_date': state.effectiveStartDate.trim(),
        'effective_end_date': state.effectiveEndDate.trim().isEmpty ? null : state.effectiveEndDate.trim(),
        'assignment_mode': state.assignmentMode.apiValue,
        'status': state.selectedStatus == PositionStatus.active ? 'ACTIVE' : 'INACTIVE',
        'weekly_lines': weeklyLines,
      };

      await createUseCase.call(data: requestData);
      workSchedulesNotifier.refresh();

      state = state.copyWith(isCreating: false);
      return true;
    } catch (e) {
      state = state.copyWith(isCreating: false, error: 'Failed to create work schedule: ${e.toString()}');
      return false;
    }
  }

  void reset() {
    state = state.reset();
  }
}

final workScheduleCreateNotifierProvider =
    StateNotifierProvider.family<WorkScheduleCreateNotifier, WorkScheduleCreateState, int>((ref, enterpriseId) {
      final createUseCase = ref.read(createWorkScheduleUseCaseProvider(enterpriseId));
      final workSchedulesNotifier = ref.read(workSchedulesNotifierProvider(enterpriseId).notifier);
      return WorkScheduleCreateNotifier(
        createUseCase: createUseCase,
        enterpriseId: enterpriseId,
        workSchedulesNotifier: workSchedulesNotifier,
      );
    });
