import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryChangeHistoryFilterState {
  final String searchQuery;
  final SalaryChangeHistoryStatus status;
  final SalaryChangeHistoryType type;
  final DateTime? pendingEffectiveFrom;
  final DateTime? pendingEffectiveTo;
  final DateTime? appliedEffectiveFrom;
  final DateTime? appliedEffectiveTo;

  const SalaryChangeHistoryFilterState({
    this.searchQuery = '',
    this.status = SalaryChangeHistoryStatus.all,
    this.type = SalaryChangeHistoryType.all,
    this.pendingEffectiveFrom,
    this.pendingEffectiveTo,
    this.appliedEffectiveFrom,
    this.appliedEffectiveTo,
  });

  bool get hasAppliedDateFilter =>
      appliedEffectiveFrom != null || appliedEffectiveTo != null;

  SalaryChangeHistoryFilterState copyWith({
    String? searchQuery,
    SalaryChangeHistoryStatus? status,
    SalaryChangeHistoryType? type,
    DateTime? pendingEffectiveFrom,
    bool clearPendingEffectiveFrom = false,
    DateTime? pendingEffectiveTo,
    bool clearPendingEffectiveTo = false,
    DateTime? appliedEffectiveFrom,
    bool clearAppliedEffectiveFrom = false,
    DateTime? appliedEffectiveTo,
    bool clearAppliedEffectiveTo = false,
  }) {
    return SalaryChangeHistoryFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      type: type ?? this.type,
      pendingEffectiveFrom: clearPendingEffectiveFrom
          ? null
          : (pendingEffectiveFrom ?? this.pendingEffectiveFrom),
      pendingEffectiveTo: clearPendingEffectiveTo
          ? null
          : (pendingEffectiveTo ?? this.pendingEffectiveTo),
      appliedEffectiveFrom: clearAppliedEffectiveFrom
          ? null
          : (appliedEffectiveFrom ?? this.appliedEffectiveFrom),
      appliedEffectiveTo: clearAppliedEffectiveTo
          ? null
          : (appliedEffectiveTo ?? this.appliedEffectiveTo),
    );
  }
}

class SalaryChangeHistoryFilterNotifier
    extends Notifier<SalaryChangeHistoryFilterState> {
  final _debouncer = Debouncer();

  @override
  SalaryChangeHistoryFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const SalaryChangeHistoryFilterState();
  }

  void setSearch(String query) {
    _debouncer.run(() => state = state.copyWith(searchQuery: query));
  }

  void setStatus(SalaryChangeHistoryStatus? value) {
    state = state.copyWith(status: value ?? SalaryChangeHistoryStatus.all);
  }

  void setType(SalaryChangeHistoryType? value) {
    state = state.copyWith(type: value ?? SalaryChangeHistoryType.all);
  }

  void setPendingEffectiveFrom(DateTime? value) {
    state = value == null
        ? state.copyWith(clearPendingEffectiveFrom: true)
        : state.copyWith(pendingEffectiveFrom: value);
  }

  void setPendingEffectiveTo(DateTime? value) {
    state = value == null
        ? state.copyWith(clearPendingEffectiveTo: true)
        : state.copyWith(pendingEffectiveTo: value);
  }

  void applyDateFilter() {
    state = state.copyWith(
      appliedEffectiveFrom: state.pendingEffectiveFrom,
      clearAppliedEffectiveFrom: state.pendingEffectiveFrom == null,
      appliedEffectiveTo: state.pendingEffectiveTo,
      clearAppliedEffectiveTo: state.pendingEffectiveTo == null,
    );
  }

  void removeDateFilter() {
    state = state.copyWith(
      clearPendingEffectiveFrom: true,
      clearPendingEffectiveTo: true,
      clearAppliedEffectiveFrom: true,
      clearAppliedEffectiveTo: true,
    );
  }

  void reset() => state = const SalaryChangeHistoryFilterState();
}

final salaryChangeHistoryFilterProvider = NotifierProvider<
    SalaryChangeHistoryFilterNotifier, SalaryChangeHistoryFilterState>(
  SalaryChangeHistoryFilterNotifier.new,
);
