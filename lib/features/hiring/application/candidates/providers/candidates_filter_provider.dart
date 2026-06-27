import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CandidatesFilterState {
  const CandidatesFilterState({this.searchQuery = '', this.status});

  final String searchQuery;
  final String? status;

  CandidatesFilterState copyWith({String? searchQuery, String? status, bool clearStatus = false}) {
    return CandidatesFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilters => searchQuery.isNotEmpty || status != null;
}

class CandidatesFilterNotifier extends Notifier<CandidatesFilterState> {
  final _debouncer = Debouncer();

  @override
  CandidatesFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const CandidatesFilterState();
  }

  void setSearch(String query) {
    _debouncer.run(() {
      state = state.copyWith(searchQuery: query);
    });
  }

  void setStatus(String? value) {
    state = value == null ? state.copyWith(clearStatus: true) : state.copyWith(status: value);
  }

  void reset() {
    state = const CandidatesFilterState();
  }
}

final candidatesFilterProvider = NotifierProvider<CandidatesFilterNotifier, CandidatesFilterState>(
  CandidatesFilterNotifier.new,
);
