import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_enterprise_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/timesheet_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewTimesheetFormState {
  final int? employeeId;
  final String? employeeName;
  final String? projectName;
  final int? projectId;
  final String? position;
  final String? departmentId;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isLoading;
  final bool isSavingDraft;
  final bool isSubmittingForApproval;
  final List<DateTime> weekDays;
  final List<double> regularHours;
  final List<double> overtimeHours;
  final List<String> taskTexts;

  const NewTimesheetFormState({
    this.employeeId,
    this.employeeName,
    this.projectName,
    this.projectId,
    this.startDate,
    this.endDate,
    this.position,
    this.departmentId,
    this.description,
    this.isLoading = false,
    this.isSavingDraft = false,
    this.isSubmittingForApproval = false,
    this.weekDays = const [],
    this.regularHours = const [],
    this.overtimeHours = const [],
    this.taskTexts = const [],
  });

  NewTimesheetFormState copyWith({
    int? employeeId,
    String? employeeName,
    String? projectName,
    int? projectId,
    DateTime? startDate,
    DateTime? endDate,
    String? position,
    String? departmentId,
    String? description,
    bool? isLoading,
    bool? isSavingDraft,
    bool? isSubmittingForApproval,
    List<DateTime>? weekDays,
    List<double>? regularHours,
    List<double>? overtimeHours,
    List<String>? taskTexts,
  }) {
    return NewTimesheetFormState(
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      projectName: projectName ?? this.projectName,
      projectId: projectId ?? this.projectId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      position: position ?? this.position,
      departmentId: departmentId ?? this.departmentId,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      isSavingDraft: isSavingDraft ?? this.isSavingDraft,
      isSubmittingForApproval:
          isSubmittingForApproval ?? this.isSubmittingForApproval,
      weekDays: weekDays ?? this.weekDays,
      regularHours: regularHours ?? this.regularHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      taskTexts: taskTexts ?? this.taskTexts,
    );
  }

  double get totalRegularHours =>
      regularHours.fold(0.0, (sum, value) => sum + value);

  double get totalOvertimeHours =>
      overtimeHours.fold(0.0, (sum, value) => sum + value);
}

class MissingTimesheetRequiredDataException implements Exception {
  const MissingTimesheetRequiredDataException();
}

class NewTimesheetNotifier extends StateNotifier<NewTimesheetFormState> {
  NewTimesheetNotifier(this._ref)
    : super(
        NewTimesheetFormState(
          startDate: DateTime.now(),
          endDate: DateTime.now().add(const Duration(days: 6)),
          weekDays: _generateWeekDays(DateTime.now()),
          regularHours: List<double>.filled(7, 0),
          overtimeHours: List<double>.filled(7, 0),
        ),
      );

  final Ref _ref;

  static List<DateTime> _generateWeekDays(DateTime start) {
    return List.generate(7, (index) => start.add(Duration(days: index)));
  }

  void setEmployee({int? employeeId, String? employeeName}) {
    state = state.copyWith(employeeId: employeeId, employeeName: employeeName);
  }

  void setProject({int? projectId, String? projectName}) {
    state = state.copyWith(projectId: projectId, projectName: projectName);
  }

  void setPosition(String? position) {
    state = state.copyWith(position: position);
  }

  void setDepartmentId(String? departmentId) {
    state = state.copyWith(departmentId: departmentId);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  void setRegularHours(int index, String value) {
    final parsed = double.tryParse(value.trim());
    final hours = List<double>.from(state.regularHours);
    if (hours.length < 7) {
      hours.addAll(List<double>.filled(7 - hours.length, 0));
    }
    if (index >= 0 && index < hours.length) {
      hours[index] = parsed ?? 0;
      state = state.copyWith(regularHours: hours);
    }
  }

  void setOvertimeHours(int index, String value) {
    final parsed = double.tryParse(value.trim());
    final hours = List<double>.from(state.overtimeHours);
    if (hours.length < 7) {
      hours.addAll(List<double>.filled(7 - hours.length, 0));
    }
    if (index >= 0 && index < hours.length) {
      hours[index] = parsed ?? 0;
      state = state.copyWith(overtimeHours: hours);
    }
  }

  void setTaskText(int index, String value) {
    final tasks = List<String>.from(state.taskTexts);
    if (tasks.length < 7) {
      tasks.addAll(List<String>.filled(7 - tasks.length, ''));
    }
    if (index >= 0 && index < tasks.length) {
      tasks[index] = value.trim();
      state = state.copyWith(taskTexts: tasks);
    }
  }

  void setStartDate(DateTime? startDate) {
    state = state.copyWith(startDate: startDate);

    final end = startDate?.add(const Duration(days: 6));

    state = state.copyWith(endDate: end);

    if (startDate != null) {
      final weekDays = List.generate(
        7,
        (index) => startDate.add(Duration(days: index)),
      );

      state = state.copyWith(
        weekDays: weekDays,
        regularHours: List<double>.filled(7, 0),
        overtimeHours: List<double>.filled(7, 0),
        taskTexts: List<String>.filled(7, ''),
      );
    }
  }

  void setEndDate(DateTime? endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  Future<void> submit(TimesheetStatus status) async {
    final enterpriseId = _ref.read(timesheetEnterpriseIdProvider);
    final repository = _ref.read(timesheetRepositoryProvider);
    final timesheetNotifier = _ref.read(timesheetNotifierProvider.notifier);
    final currentState = state;

    if (enterpriseId == null ||
        currentState.employeeId == null ||
        currentState.startDate == null ||
        currentState.endDate == null) {
      throw const MissingTimesheetRequiredDataException();
    }

    final isDraft = status == TimesheetStatus.draft;
    final isSubmitted = status == TimesheetStatus.submitted;

    state = state.copyWith(
      isLoading: true,
      isSavingDraft: isDraft,
      isSubmittingForApproval: isSubmitted,
    );
    try {
      final body = _buildCreateRequestBody(
        state: currentState,
        enterpriseId: enterpriseId,
        status: status,
      );

      await repository.createTimesheet(body);
      await timesheetNotifier.refresh();
    } finally {
      state = state.copyWith(
        isLoading: false,
        isSavingDraft: false,
        isSubmittingForApproval: false,
      );
    }
  }

  Map<String, dynamic> _buildCreateRequestBody({
    required NewTimesheetFormState state,
    required int enterpriseId,
    required TimesheetStatus status,
  }) {
    String formatDate(DateTime date) =>
        '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';

    String buildWeekRef(DateTime start) {
      final firstDayOfYear = DateTime(start.year, 1, 1);
      final diff = start.difference(firstDayOfYear).inDays;
      final week = (diff / 7).floor() + 1;
      final weekStr = week.toString().padLeft(2, '0');
      return 'W$weekStr-${start.year}';
    }

    final startDate = state.startDate!;
    final endDate = state.endDate!;

    final lines = <Map<String, dynamic>>[];
    for (var i = 0; i < state.weekDays.length; i++) {
      final workDate = state.weekDays[i];
      final regular = i < state.regularHours.length
          ? state.regularHours[i]
          : 0.0;
      final overtime = i < state.overtimeHours.length
          ? state.overtimeHours[i]
          : 0.0;
      final taskText = i < state.taskTexts.length ? state.taskTexts[i] : '';

      if (regular == 0 && overtime == 0 && taskText.isEmpty) {
        continue;
      }

      lines.add({
        'work_date': formatDate(workDate),
        'project_id': state.projectId,
        'project_task_text': taskText.isEmpty ? null : taskText,
        'regular_hours': regular,
        'ot_hours': overtime,
        'line_notes': taskText.isEmpty ? null : taskText,
      });
    }

    return {
      'enterprise_id': enterpriseId,
      'employee_id': state.employeeId,
      'week_start_date': formatDate(startDate),
      'week_end_date': formatDate(endDate),
      'status_code': status.toApiString().toUpperCase(),
      'project_name': state.projectName,
      'description': state.description,
      'attendance_week_ref': buildWeekRef(startDate),
      'is_active': 'Y',
      'created_by': 'admin',
      'updated_by': 'admin',
      'lines': lines,
    };
  }

  void reset() {
    state = NewTimesheetFormState(
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 6)),
      weekDays: _generateWeekDays(DateTime.now()),
      regularHours: List<double>.filled(7, 0),
      overtimeHours: List<double>.filled(7, 0),
      taskTexts: List<String>.filled(7, ''),
    );
  }
}

final newTimesheetProvider =
    StateNotifierProvider<NewTimesheetNotifier, NewTimesheetFormState>(
      (ref) => NewTimesheetNotifier(ref),
    );
