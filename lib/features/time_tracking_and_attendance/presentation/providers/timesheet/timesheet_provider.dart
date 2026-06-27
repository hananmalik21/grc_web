import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/time_tracking_and_attendance/data/repositories/timesheet_repository_impl.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/timesheet_repository.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/usecases/timesheet/get_timesheet_statistics_usecase.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/usecases/timesheet/get_timesheets_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final timesheetApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final timesheetRepositoryProvider = Provider<TimesheetRepository>((ref) {
  final client = ref.watch(timesheetApiClientProvider);
  return TimesheetRepositoryImpl(apiClient: client);
});

class TimesheetState {
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final bool isWeekFilterEnabled;
  final String searchQuery;
  final TimesheetStatus? statusFilter;
  final String? companyId;
  final String? divisionId;
  final String? departmentId;
  final String? sectionId;
  final String? orgUnitId;
  final String? levelCode;
  final int total;
  final int draft;
  final int submitted;
  final int approved;
  final int rejected;
  final double regularHours;
  final double overtimeHours;
  final bool isLoading;
  final String? approvingTimesheetGuid;
  final String? rejectingTimesheetGuid;
  final String? error;
  final List<Timesheet> records;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final bool isCurrentWeek;

  const TimesheetState({
    required this.weekStartDate,
    required this.weekEndDate,
    this.isWeekFilterEnabled = false,
    this.searchQuery = '',
    this.statusFilter,
    this.companyId,
    this.divisionId,
    this.departmentId,
    this.sectionId,
    this.orgUnitId,
    this.levelCode,
    this.total = 0,
    this.draft = 0,
    this.submitted = 0,
    this.approved = 0,
    this.rejected = 0,
    this.regularHours = 0.0,
    this.overtimeHours = 0.0,
    this.isLoading = false,
    this.approvingTimesheetGuid,
    this.rejectingTimesheetGuid,
    this.error,
    this.records = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.isCurrentWeek = true,
  });

  TimesheetState copyWith({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? searchQuery,
    TimesheetStatus? statusFilter,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    String? orgUnitId,
    String? levelCode,
    int? total,
    int? draft,
    int? submitted,
    int? approved,
    int? rejected,
    double? regularHours,
    double? overtimeHours,
    bool? isLoading,
    String? approvingTimesheetGuid,
    String? rejectingTimesheetGuid,
    String? error,
    List<Timesheet>? records,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    bool clearError = false,
    bool clearStatusFilter = false,
    bool clearOrgUnitId = false,
    bool clearLevelCode = false,
    bool clearApprovingTimesheetGuid = false,
    bool clearRejectingTimesheetGuid = false,
    bool? isCurrentWeek,
    bool? isWeekFilterEnabled,
  }) {
    return TimesheetState(
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      isWeekFilterEnabled: isWeekFilterEnabled ?? this.isWeekFilterEnabled,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      companyId: companyId ?? this.companyId,
      divisionId: divisionId ?? this.divisionId,
      departmentId: departmentId ?? this.departmentId,
      sectionId: sectionId ?? this.sectionId,
      orgUnitId: clearOrgUnitId ? null : (orgUnitId ?? this.orgUnitId),
      levelCode: clearLevelCode ? null : (levelCode ?? this.levelCode),
      total: total ?? this.total,
      draft: draft ?? this.draft,
      submitted: submitted ?? this.submitted,
      approved: approved ?? this.approved,
      rejected: rejected ?? this.rejected,
      regularHours: regularHours ?? this.regularHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      isLoading: isLoading ?? this.isLoading,
      approvingTimesheetGuid: clearApprovingTimesheetGuid
          ? null
          : (approvingTimesheetGuid ?? this.approvingTimesheetGuid),
      rejectingTimesheetGuid: clearRejectingTimesheetGuid
          ? null
          : (rejectingTimesheetGuid ?? this.rejectingTimesheetGuid),
      error: clearError ? null : (error ?? this.error),
      records: records ?? this.records,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      isCurrentWeek: isCurrentWeek ?? this.isCurrentWeek,
    );
  }
}

class TimesheetNotifier extends StateNotifier<TimesheetState> {
  final GetTimesheetsUseCase _getTimesheets;
  final GetTimesheetStatisticsUseCase _getStatistics;
  final TimesheetRepository _repository;
  Debouncer? _searchDebouncer;

  TimesheetNotifier({
    required GetTimesheetsUseCase getTimesheetsUseCase,
    required GetTimesheetStatisticsUseCase getTimesheetStatisticsUseCase,
    required TimesheetRepository repository,
  }) : _getTimesheets = getTimesheetsUseCase,
       _getStatistics = getTimesheetStatisticsUseCase,
       _repository = repository,
       super(
         TimesheetState(
           weekStartDate: DateTimeUtils.getWeekStart(DateTime.now()),
           weekEndDate: DateTimeUtils.getWeekEnd(DateTime.now()),
         ),
       ) {
    loadTimesheets();
  }

  static bool _isCurrentWeekRange(DateTime start, DateTime end) {
    return DateTimeUtils.isDateInRange(start: start, end: end);
  }

  /// Loads timesheets from repository
  Future<void> loadTimesheets() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final weekStart = state.isWeekFilterEnabled ? state.weekStartDate : null;
      final weekEnd = state.isWeekFilterEnabled ? state.weekEndDate : null;

      final stats = await _getStatistics(
        weekStartDate: weekStart,
        weekEndDate: weekEnd,
        companyId: state.companyId,
        divisionId: state.divisionId,
        departmentId: state.departmentId,
        sectionId: state.sectionId,
      );

      final pageResult = await _getTimesheets(
        weekStartDate: weekStart,
        weekEndDate: weekEnd,
        searchQuery: state.searchQuery.isEmpty ? null : state.searchQuery,
        status: state.statusFilter,
        companyId: state.companyId,
        divisionId: state.divisionId,
        departmentId: state.departmentId,
        sectionId: state.sectionId,
        orgUnitId: state.orgUnitId,
        levelCode: state.levelCode,
        page: state.currentPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        records: pageResult.items,
        totalItems: pageResult.total,
        total: stats.total,
        draft: stats.draft,
        submitted: stats.submitted,
        approved: stats.approved,
        rejected: stats.rejected,
        regularHours: stats.regHours,
        overtimeHours: stats.otHours,
        isLoading: false,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load timesheets: ${e.toString()}', clearError: false);
    }
  }

  /// Refreshes timesheet data
  Future<void> refresh() async {
    await loadTimesheets();
  }

  void setWeek(DateTime weekStart) {
    final normalizedStart = DateTimeUtils.getWeekStart(weekStart);
    final weekEnd = normalizedStart.add(const Duration(days: 6));
    state = state.copyWith(
      weekStartDate: normalizedStart,
      weekEndDate: weekEnd,
      isCurrentWeek: _isCurrentWeekRange(normalizedStart, weekEnd),
    );
  }

  void goToCurrentWeek() {
    final now = DateTime.now();
    setWeek(DateTimeUtils.getWeekStart(now));
  }

  void clearWeekFilter() {
    state = state.copyWith(isWeekFilterEnabled: false);
    loadTimesheets();
  }

  void applyWeekFilter() {
    state = state.copyWith(isWeekFilterEnabled: true);
    loadTimesheets();
  }

  void goToPreviousWeek() {
    final newStart = state.weekStartDate.subtract(const Duration(days: 7));
    setWeek(newStart);
  }

  void goToNextWeek() {
    final newStart = state.weekStartDate.add(const Duration(days: 7));
    setWeek(newStart);
  }

  void setSearchQuery(String query) {
    _searchDebouncer ??= Debouncer(delay: const Duration(milliseconds: 400));
    final trimmed = query.trim();
    _searchDebouncer!.run(() {
      state = state.copyWith(searchQuery: trimmed, currentPage: 1);
      loadTimesheets();
    });
  }

  void setStatusFilter(TimesheetStatus? status) {
    state = state.copyWith(statusFilter: status, clearStatusFilter: status == null);
    loadTimesheets();
  }

  void setCompanyId(String? companyId) {
    state = state.copyWith(companyId: companyId, divisionId: null, departmentId: null, sectionId: null);
    loadTimesheets();
  }

  void setDivisionId(String? divisionId) {
    state = state.copyWith(divisionId: divisionId, departmentId: null, sectionId: null);
    loadTimesheets();
  }

  void setDepartmentId(String? departmentId) {
    state = state.copyWith(departmentId: departmentId, sectionId: null);
    loadTimesheets();
  }

  void setSectionId(String? sectionId) {
    state = state.copyWith(sectionId: sectionId);
    loadTimesheets();
  }

  void setOrgFilter(String? orgUnitId, String? levelCode) {
    state = state.copyWith(
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      clearOrgUnitId: orgUnitId == null,
      clearLevelCode: levelCode == null,
    );
    loadTimesheets();
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
    loadTimesheets();
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, currentPage: 1);
    loadTimesheets();
  }

  /// Approves a timesheet by GUID. Returns null on success, error message on failure.
  Future<String?> approveTimesheet(String timesheetGuid) async {
    state = state.copyWith(approvingTimesheetGuid: timesheetGuid);
    try {
      await _repository.approveTimesheet(timesheetGuid);
      final records = [...state.records];
      final index = records.indexWhere((t) => t.guid == timesheetGuid);

      if (index != -1) {
        final current = records[index];

        final updated = Timesheet(
          id: current.id,
          guid: current.guid,
          employeeId: current.employeeId,
          employeeName: current.employeeName,
          employeeNumber: current.employeeNumber,
          departmentName: current.departmentName,
          companyName: current.companyName,
          divisionName: current.divisionName,
          weekStartDate: current.weekStartDate,
          weekEndDate: current.weekEndDate,
          regularHours: current.regularHours,
          overtimeHours: current.overtimeHours,
          totalHours: current.totalHours,
          status: TimesheetStatus.approved,
          description: current.description,
          createdAt: current.createdAt,
          updatedAt: DateTime.now(),
          submittedAt: current.submittedAt,
          approvedAt: DateTime.now(),
          rejectedAt: null,
          rejectionReason: null,
          lines: current.lines,
        );

        records[index] = updated;

        var submitted = state.submitted;
        var approved = state.approved;

        if (current.status == TimesheetStatus.submitted) {
          submitted = submitted > 0 ? submitted - 1 : 0;
          approved = approved + 1;
        }

        state = state.copyWith(records: records, submitted: submitted, approved: approved);
      }

      return null;
    } catch (e) {
      final message = 'Failed to approve timesheet: ${e.toString()}';
      state = state.copyWith(error: message, clearError: false);
      return message;
    } finally {
      state = state.copyWith(clearApprovingTimesheetGuid: true);
    }
  }

  Future<String?> rejectTimesheet(String timesheetGuid, {required String rejectReason}) async {
    state = state.copyWith(rejectingTimesheetGuid: timesheetGuid);
    try {
      await _repository.rejectTimesheet(timesheetGuid, rejectReason: rejectReason);

      // Optimistically update the rejected timesheet in the current list
      final records = [...state.records];
      final index = records.indexWhere((t) => t.guid == timesheetGuid);

      if (index != -1) {
        final current = records[index];

        final updated = Timesheet(
          id: current.id,
          guid: current.guid,
          employeeId: current.employeeId,
          employeeName: current.employeeName,
          employeeNumber: current.employeeNumber,
          departmentName: current.departmentName,
          companyName: current.companyName,
          divisionName: current.divisionName,
          weekStartDate: current.weekStartDate,
          weekEndDate: current.weekEndDate,
          regularHours: current.regularHours,
          overtimeHours: current.overtimeHours,
          totalHours: current.totalHours,
          status: TimesheetStatus.rejected,
          description: current.description,
          createdAt: current.createdAt,
          updatedAt: DateTime.now(),
          submittedAt: current.submittedAt,
          approvedAt: current.approvedAt,
          rejectedAt: DateTime.now(),
          rejectionReason: rejectReason,
          lines: current.lines,
        );

        records[index] = updated;

        var submitted = state.submitted;
        var rejected = state.rejected;

        if (current.status == TimesheetStatus.submitted) {
          submitted = submitted > 0 ? submitted - 1 : 0;
          rejected = rejected + 1;
        }

        state = state.copyWith(records: records, submitted: submitted, rejected: rejected);
      }

      return null;
    } catch (e) {
      final message = 'Failed to reject timesheet: ${e.toString()}';
      state = state.copyWith(error: message, clearError: false);
      return message;
    } finally {
      state = state.copyWith(clearRejectingTimesheetGuid: true);
    }
  }
}

// State Notifier Provider
final timesheetNotifierProvider = StateNotifierProvider<TimesheetNotifier, TimesheetState>((ref) {
  final repository = ref.watch(timesheetRepositoryProvider);
  final getTimesheets = GetTimesheetsUseCase(repository: repository);
  final getStats = GetTimesheetStatisticsUseCase(repository: repository);

  return TimesheetNotifier(
    getTimesheetsUseCase: getTimesheets,
    getTimesheetStatisticsUseCase: getStats,
    repository: repository,
  );
});
