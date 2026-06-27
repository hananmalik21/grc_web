import 'package:grc/core/services/debouncer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterviewsFilterState {
  const InterviewsFilterState({this.searchQuery = '', this.status});

  final String searchQuery;
  final String? status;

  InterviewsFilterState copyWith({String? searchQuery, String? status, bool clearStatus = false}) {
    return InterviewsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
    );
  }

  bool get hasActiveFilters => searchQuery.isNotEmpty || status != null;
}

class InterviewsFilterNotifier extends Notifier<InterviewsFilterState> {
  final _debouncer = Debouncer();

  @override
  InterviewsFilterState build() {
    ref.onDispose(_debouncer.dispose);
    return const InterviewsFilterState();
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
    state = const InterviewsFilterState();
  }
}

final interviewsFilterProvider = NotifierProvider<InterviewsFilterNotifier, InterviewsFilterState>(
  InterviewsFilterNotifier.new,
);
