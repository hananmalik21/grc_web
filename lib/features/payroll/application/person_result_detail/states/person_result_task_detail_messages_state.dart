import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';

class PersonResultTaskDetailMessagesState {
  const PersonResultTaskDetailMessagesState({
    this.searchQuery = '',
    this.severityFilter = PersonResultTaskDetailMessageSeverityFilter.all,
    this.expandedRowIds = const {},
  });

  final String searchQuery;
  final PersonResultTaskDetailMessageSeverityFilter severityFilter;
  final Set<String> expandedRowIds;

  PersonResultTaskDetailMessagesState copyWith({
    String? searchQuery,
    PersonResultTaskDetailMessageSeverityFilter? severityFilter,
    Set<String>? expandedRowIds,
  }) {
    return PersonResultTaskDetailMessagesState(
      searchQuery: searchQuery ?? this.searchQuery,
      severityFilter: severityFilter ?? this.severityFilter,
      expandedRowIds: expandedRowIds ?? this.expandedRowIds,
    );
  }
}
