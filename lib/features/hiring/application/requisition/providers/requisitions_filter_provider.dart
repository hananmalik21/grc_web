import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_table_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequisitionsFilterState {
  const RequisitionsFilterState({
    this.searchQuery = '',
    this.department,
    this.priority,
    this.status,
    this.workMode,
    this.employmentType,
  });

  final String searchQuery;
  final String? department;
  final String? priority;
  final String? status;
  final String? workMode;
  final String? employmentType;

  RequisitionsFilterState copyWith({
    String? searchQuery,
    String? department,
    bool clearDepartment = false,
    String? priority,
    bool clearPriority = false,
    String? status,
    bool clearStatus = false,
    String? workMode,
    bool clearWorkMode = false,
    String? employmentType,
    bool clearEmploymentType = false,
  }) {
    return RequisitionsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      department: clearDepartment ? null : (department ?? this.department),
      priority: clearPriority ? null : (priority ?? this.priority),
      status: clearStatus ? null : (status ?? this.status),
      workMode: clearWorkMode ? null : (workMode ?? this.workMode),
      employmentType: clearEmploymentType ? null : (employmentType ?? this.employmentType),
    );
  }

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      department != null ||
      priority != null ||
      status != null ||
      workMode != null ||
      employmentType != null;
}

class RequisitionsFilterNotifier extends AutoDisposeNotifier<RequisitionsFilterState> {
  final _debouncer = Debouncer();

  @override
  RequisitionsFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const RequisitionsFilterState();
  }

  void setSearch(String query) {
    _debouncer.run(() {
      state = state.copyWith(searchQuery: query);
      _resetPage();
    });
  }

  void setDepartment(String? value) {
    state = value == null ? state.copyWith(clearDepartment: true) : state.copyWith(department: value);
    _resetPage();
  }

  void setPriority(String? value) {
    state = value == null ? state.copyWith(clearPriority: true) : state.copyWith(priority: value);
    _resetPage();
  }

  void setStatus(String? value) {
    state = value == null ? state.copyWith(clearStatus: true) : state.copyWith(status: value);
    _resetPage();
  }

  void setWorkMode(String? value) {
    state = value == null ? state.copyWith(clearWorkMode: true) : state.copyWith(workMode: value);
    _resetPage();
  }

  void setEmploymentType(String? value) {
    state = value == null ? state.copyWith(clearEmploymentType: true) : state.copyWith(employmentType: value);
    _resetPage();
  }

  void reset() {
    state = const RequisitionsFilterState();
    _resetPage();
  }

  void _resetPage() {
    ref.read(requisitionsCurrentPageProvider.notifier).state = requisitionsDefaultPage;
  }
}

final requisitionsFilterProvider = NotifierProvider.autoDispose<RequisitionsFilterNotifier, RequisitionsFilterState>(
  RequisitionsFilterNotifier.new,
);

final requisitionsShowFiltersProvider = StateProvider.autoDispose<bool>((ref) => false);
