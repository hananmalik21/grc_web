import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/models/time_zone.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/domain/usecases/update_work_schedule_usecase.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedule_update_state.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkScheduleUpdateNotifier extends StateNotifier<WorkScheduleUpdateState> {
  final UpdateWorkScheduleUseCase _updateUseCase;
  final int _enterpriseId;
  final int _scheduleId;
  final WorkSchedulesNotifier _workSchedulesNotifier;

  WorkScheduleUpdateNotifier({
    required UpdateWorkScheduleUseCase updateUseCase,
    required int enterpriseId,
    required int scheduleId,
    required WorkSchedulesNotifier workSchedulesNotifier,
  }) : _updateUseCase = updateUseCase,
       _enterpriseId = enterpriseId,
       _scheduleId = scheduleId,
       _workSchedulesNotifier = workSchedulesNotifier,
       super(const WorkScheduleUpdateState());

  void initializeFromSchedule(
    WorkSchedule schedule,
    List<ShiftOverview> availableShifts,
    List<WorkPattern> availableWorkPatterns,
  ) {
    final dayShifts = <int, ShiftOverview?>{};

    for (final line in schedule.weeklyLines) {
      if (line.dayType == 'WORK' && line.shift != null) {
        final shiftId = line.shift!.shiftId;
        final shift = availableShifts.firstWhere(
          (s) => s.id == shiftId,
          orElse: () => _createShiftOverviewFromWorkScheduleShift(line.shift!),
        );
        dayShifts[line.dayOfWeek] = shift;
      }
    }

    WorkPattern? workPattern;
    try {
      workPattern = availableWorkPatterns.firstWhere((p) => p.workPatternId == schedule.workPatternId);
    } catch (_) {
      final patternDays = schedule.weeklyLines
          .map((line) => WorkPatternDay(dayOfWeek: line.dayOfWeek, dayType: line.dayType))
          .toList();

      workPattern = WorkPattern(
        workPatternId: schedule.workPatternId,
        tenantId: schedule.tenantId,
        patternCode: '',
        patternNameEn: schedule.patternNameEn ?? '',
        patternNameAr: schedule.patternNameAr ?? '',
        patternType: 'SCHEDULE_DERIVED',
        totalHoursPerWeek: 0,
        status: schedule.status,
        creationDate: schedule.creationDate,
        createdBy: schedule.createdBy,
        lastUpdateDate: schedule.lastUpdateDate,
        lastUpdatedBy: schedule.lastUpdatedBy,
        days: patternDays,
      );
    }

    ShiftOverview? sameShiftForAllDays;
    if (schedule.assignmentMode == 'SAME_SHIFT_ALL_DAYS') {
      final workLines = schedule.weeklyLines.where((l) => l.dayType == 'WORK' && l.shift != null).toList();
      if (workLines.isNotEmpty) {
        final firstShiftId = workLines.first.shift!.shiftId;
        final allSameShift = workLines.every((l) => l.shift!.shiftId == firstShiftId);
        if (allSameShift) {
          final anyLineShift = workLines.first.shift!;
          sameShiftForAllDays = availableShifts.firstWhere(
            (s) => s.id == firstShiftId,
            orElse: () => _createShiftOverviewFromWorkScheduleShift(anyLineShift),
          );
        }
      }
    }

    state = state.copyWith(
      scheduleCode: schedule.scheduleCode,
      scheduleNameEn: schedule.scheduleNameEn,
      scheduleNameAr: schedule.scheduleNameAr,
      effectiveStartDate: schedule.formattedStartDate,
      effectiveEndDate: schedule.formattedEndDate,
      selectedTimeZone: TimeZone(tzName: schedule.timeZone),
      selectedWorkPattern: workPattern,
      selectedStatus: schedule.status,
      assignmentMode: WorkScheduleAssignmentMode.fromApiValue(schedule.assignmentMode),
      dayShifts: dayShifts,
      sameShiftForAllDays: sameShiftForAllDays,
    );
  }

  ShiftOverview _createShiftOverviewFromWorkScheduleShift(WorkScheduleShift shift) {
    return ShiftOverview(
      id: shift.shiftId,
      name: shift.shiftNameEn,
      nameAr: shift.shiftNameAr,
      code: shift.shiftCode,
      startTime: _formatTimeFromMinutes(shift.startMinutes),
      endTime: _formatTimeFromMinutes(shift.endMinutes),
      totalHours: shift.durationHours,
      breakHours: shift.breakHours,
      shiftType: _parseShiftType(shift.shiftType),
      shiftTypeRaw: shift.shiftType,
      status: shift.status == PositionStatus.active ? ShiftStatus.active : ShiftStatus.inactive,
      colorHex: shift.colorHex,
    );
  }

  String _formatTimeFromMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  ShiftType _parseShiftType(String type) {
    switch (type.toUpperCase()) {
      case 'DAY':
        return ShiftType.day;
      case 'EVENING':
        return ShiftType.evening;
      case 'NIGHT':
        return ShiftType.night;
      case 'ROTATING':
        return ShiftType.rotating;
      default:
        return ShiftType.day;
    }
  }

  void setScheduleCode(String code) {
    state = state.copyWith(scheduleCode: code);
  }

  void setScheduleNameEn(String name) {
    state = state.copyWith(scheduleNameEn: name);
  }

  void setScheduleNameAr(String name) {
    state = state.copyWith(scheduleNameAr: name);
  }

  void setEffectiveStartDate(String date) {
    state = state.copyWith(effectiveStartDate: date);
  }

  void setEffectiveEndDate(String date) {
    state = state.copyWith(effectiveEndDate: date);
  }

  void setSelectedWorkPattern(WorkPattern? pattern) {
    state = state.copyWith(selectedWorkPattern: pattern);
  }

  void setSelectedStatus(PositionStatus status) {
    state = state.copyWith(selectedStatus: status);
  }

  void setSelectedTimeZone(TimeZone? timeZone) {
    state = state.copyWith(selectedTimeZone: timeZone, clearTimeZone: timeZone == null);
  }

  void setAssignmentMode(WorkScheduleAssignmentMode mode) {
    if (mode == state.assignmentMode) return;

    if (mode == WorkScheduleAssignmentMode.sameShiftAllDays) {
      state = state.copyWith(assignmentMode: mode, clearDayShifts: true);
      return;
    }

    if (state.assignmentMode == WorkScheduleAssignmentMode.sameShiftAllDays &&
        mode == WorkScheduleAssignmentMode.perDayShift) {
      state = state.copyWith(assignmentMode: mode, clearSameShift: true, clearDayShifts: true);
      return;
    }

    state = state.copyWith(assignmentMode: mode, clearSameShift: true);
  }

  void setSameShiftForAllDays(ShiftOverview? shift) {
    state = state.copyWith(sameShiftForAllDays: shift);
  }

  void setDayShift(int dayOfWeek, ShiftOverview? shift) {
    final newDayShifts = Map<int, ShiftOverview?>.from(state.dayShifts);
    if (shift == null) {
      newDayShifts.remove(dayOfWeek);
    } else {
      newDayShifts[dayOfWeek] = shift;
    }
    state = state.copyWith(dayShifts: newDayShifts);
  }

  void reset() {
    state = const WorkScheduleUpdateState();
  }

  Future<bool> update() async {
    state = state.copyWith(isUpdating: true, error: null);

    try {
      final weeklyLines = <Map<String, dynamic>>[];

      if (state.assignmentMode == WorkScheduleAssignmentMode.sameShiftAllDays) {
        if (state.selectedWorkPattern == null || state.sameShiftForAllDays == null) {
          state = state.copyWith(isUpdating: false, error: 'Please select a work pattern and a shift for all days');
          return false;
        }

        final pattern = state.selectedWorkPattern!;
        final sameShift = state.sameShiftForAllDays!;

        for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
          final patternDay = pattern.days.firstWhere(
            (d) => d.dayOfWeek == dayOfWeek,
            orElse: () => WorkPatternDay(dayOfWeek: dayOfWeek, dayType: 'REST'),
          );

          if (patternDay.dayType == 'WORK') {
            weeklyLines.add({'day_of_week': dayOfWeek, 'day_type': 'WORK', 'shift_id': sameShift.id});
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

      final requestData = <String, dynamic>{
        'tenant_id': _enterpriseId,
        'schedule_name_en': state.scheduleNameEn.trim(),
        'schedule_name_ar': state.scheduleNameAr.trim(),
        if (state.selectedTimeZone != null) 'time_zone': state.selectedTimeZone!.tzName,
        if (state.selectedWorkPattern != null) 'work_pattern_id': state.selectedWorkPattern!.workPatternId,
        if (state.effectiveStartDate.trim().isNotEmpty) 'effective_start_date': state.effectiveStartDate.trim(),
        'effective_end_date': state.effectiveEndDate.trim().isEmpty ? null : state.effectiveEndDate.trim(),
        'assignment_mode': state.assignmentMode.apiValue,
        'status': state.selectedStatus == PositionStatus.active ? 'ACTIVE' : 'INACTIVE',
        'weekly_lines': weeklyLines,
      };

      await _updateUseCase.call(scheduleId: _scheduleId, data: requestData);
      _workSchedulesNotifier.refresh();
      state = state.copyWith(isUpdating: false);
      return true;
    } catch (e) {
      state = state.copyWith(isUpdating: false, error: e.toString());
      return false;
    }
  }
}

final workScheduleUpdateNotifierProvider =
    StateNotifierProvider.family<
      WorkScheduleUpdateNotifier,
      WorkScheduleUpdateState,
      ({int enterpriseId, int scheduleId})
    >((ref, params) {
      final updateUseCase = ref.read(updateWorkScheduleUseCaseProvider(params.enterpriseId));
      final workSchedulesNotifier = ref.read(workSchedulesNotifierProvider(params.enterpriseId).notifier);
      return WorkScheduleUpdateNotifier(
        updateUseCase: updateUseCase,
        enterpriseId: params.enterpriseId,
        scheduleId: params.scheduleId,
        workSchedulesNotifier: workSchedulesNotifier,
      );
    });
