import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SalaryStructureFilterState {
  final String searchQuery;
  final SalaryStructureStatus? status;

  const SalaryStructureFilterState({this.searchQuery = '', this.status});

  SalaryStructureFilterState copyWith({
    String? searchQuery,
    SalaryStructureStatus? status,
    bool clearStatus = false,
  }) {
    return SalaryStructureFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilters => searchQuery.isNotEmpty || status != null;
}

class SalaryStructureFilterNotifier extends Notifier<SalaryStructureFilterState> {
  final _debouncer = Debouncer();

  @override
  SalaryStructureFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const SalaryStructureFilterState();
  }

  void setSearch(String query) {
    _debouncer.run(() => state = state.copyWith(searchQuery: query));
  }

  void setStatus(SalaryStructureStatus? value) {
    state = value == null ? state.copyWith(clearStatus: true) : state.copyWith(status: value);
  }

  void reset() => state = const SalaryStructureFilterState();
}

final salaryStructureFilterProvider =
    NotifierProvider<SalaryStructureFilterNotifier, SalaryStructureFilterState>(
  SalaryStructureFilterNotifier.new,
);
