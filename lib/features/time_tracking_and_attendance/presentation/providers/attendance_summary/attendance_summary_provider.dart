import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../data/repositories/attendance_summary_repository_impl.dart';
import '../../../domain/models/attendance_summary/attendance_summary_record.dart';
import '../../../domain/repositories/attendance_summary_repository.dart';
import '../../../domain/usecases/attendance_summary/get_attendance_summary_usecase.dart';

final attendanceSummaryRepositoryProvider = Provider<AttendanceSummaryRepository>(
  (ref) => AttendanceSummaryRepositoryImpl(),
);

final getAttendanceSummaryUseCaseProvider = Provider<GetAttendanceSummaryUseCase>((ref) {
  final repository = ref.watch(attendanceSummaryRepositoryProvider);
  return GetAttendanceSummaryUseCase(repository: repository);
});

class AttendanceSummary {
  final String? companyId;
  final String? orgUnitId;
  final String? levelCode;
  final String? date;
  final DateTime? fromDate;
  final DateTime? toDate;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final bool hasSearched;
  final List<AttendanceSummaryRecord> records;
  bool isLoading;
  String? error;

  AttendanceSummary({
    this.companyId,
    this.orgUnitId,
    this.levelCode,
    this.date,
    this.fromDate,
    this.toDate,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.hasSearched = false,
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  AttendanceSummary copyWith({
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    String? date,
    DateTime? fromDate,
    DateTime? toDate,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    bool? hasSearched,
    List<AttendanceSummaryRecord>? records,
    bool? isLoading,
    String? error,
    bool clearOrgFilter = false,
    bool clearDate = false,
    bool clearDateRange = false,
    bool clearError = false,
  }) {
    return AttendanceSummary(
      companyId: companyId ?? this.companyId,
      orgUnitId: clearOrgFilter ? null : (orgUnitId ?? this.orgUnitId),
      levelCode: clearOrgFilter ? null : (levelCode ?? this.levelCode),
      date: clearDate ? null : (date ?? this.date),
      fromDate: clearDateRange ? null : (fromDate ?? this.fromDate),
      toDate: clearDateRange ? null : (toDate ?? this.toDate),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      hasSearched: hasSearched ?? this.hasSearched,
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AttendanceSummaryNotifier extends StateNotifier<AttendanceSummary> {
  final AttendanceSummaryRepository _repository;
  AttendanceSummaryNotifier(this._repository) : super(AttendanceSummary()) {
    loadAttendanceSummary();
  }

  Future<void> refresh() async {
    await loadAttendanceSummary();
  }

  Future<void> loadAttendanceSummary() async {
    if (state.companyId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final page = await _repository.getAttendanceSummaryRecords(
        companyId: state.companyId!,
        orgUnitId: state.orgUnitId,
        levelCode: state.levelCode,
        date: state.date,
        fromDate: state.fromDate?.toIso8601String().split('T').first,
        toDate: state.toDate?.toIso8601String().split('T').first,
        page: state.currentPage,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        records: page.records,
        currentPage: page.page,
        pageSize: page.pageSize,
        totalItems: page.total,
        totalPages: page.totalPages,
        hasNext: page.hasNext,
        hasPrevious: page.hasPrevious,
        isLoading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message, clearError: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load attendance: ${e.toString()}', clearError: false);
    }
  }

  void setCompanyId(String companyId) {
    state = state.copyWith(companyId: companyId, currentPage: 1, hasSearched: true);
    loadAttendanceSummary();
  }

  void setOrgFilter(String? orgUnitId, String? levelCode) {
    state = state.copyWith(
      orgUnitId: orgUnitId,
      levelCode: levelCode,
      currentPage: 1,
      clearOrgFilter: orgUnitId == null && levelCode == null,
      hasSearched: state.companyId != null,
    );
    loadAttendanceSummary();
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
    loadAttendanceSummary();
  }

  void setPageSize(int pageSize) {
    state = state.copyWith(pageSize: pageSize, currentPage: 1);
    loadAttendanceSummary();
  }

  void setDate(String? date) {
    state = state.copyWith(
      date: date,
      clearDate: date == null,
      clearDateRange: date != null,
      currentPage: 1,
      hasSearched: state.companyId != null,
    );
    loadAttendanceSummary();
  }

  void setFromDate(DateTime? date) {
    state = state.copyWith(fromDate: date);
  }

  void setToDate(DateTime? date) {
    state = state.copyWith(toDate: date);
  }

  void applyDateRange() {
    final from = state.fromDate;
    final to = state.toDate;

    if ((from != null && to == null) || (from == null && to != null)) {
      final exact = from ?? to;
      state = state.copyWith(
        fromDate: exact,
        toDate: exact,
        clearDate: true,
        currentPage: 1,
        hasSearched: state.companyId != null,
      );
      loadAttendanceSummary();
      return;
    }

    if (from != null && to != null) {
      final start = from.isBefore(to) ? from : to;
      final end = from.isBefore(to) ? to : from;
      state = state.copyWith(
        fromDate: start,
        toDate: end,
        clearDate: true,
        currentPage: 1,
        hasSearched: state.companyId != null,
      );
      loadAttendanceSummary();
      return;
    }

    clearDateFilters();
  }

  void clearDateFilters() {
    state = state.copyWith(clearDate: true, clearDateRange: true, currentPage: 1);
    loadAttendanceSummary();
  }
}

final attendanceSummaryProvider = StateNotifierProvider<AttendanceSummaryNotifier, AttendanceSummary>((ref) {
  final repository = ref.watch(attendanceSummaryRepositoryProvider);
  return AttendanceSummaryNotifier(repository);
});
