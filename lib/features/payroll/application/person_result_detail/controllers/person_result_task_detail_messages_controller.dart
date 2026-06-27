import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';
import 'package:grc/features/payroll/application/person_result_detail/states/person_result_task_detail_messages_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonResultTaskDetailMessagesController extends StateNotifier<PersonResultTaskDetailMessagesState> {
  PersonResultTaskDetailMessagesController() : super(const PersonResultTaskDetailMessagesState());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSeverityFilter(PersonResultTaskDetailMessageSeverityFilter filter) {
    if (state.severityFilter == filter) return;
    state = state.copyWith(severityFilter: filter);
  }

  void toggleRowExpanded(String id) {
    final expandedRowIds = Set<String>.from(state.expandedRowIds);
    if (expandedRowIds.contains(id)) {
      expandedRowIds.remove(id);
    } else {
      expandedRowIds.add(id);
    }
    state = state.copyWith(expandedRowIds: expandedRowIds);
  }

  void expandAll() {
    state = state.copyWith(expandedRowIds: kPersonResultTaskDetailMessageRowIds.toSet());
  }

  void collapseAll() {
    state = state.copyWith(expandedRowIds: {});
  }
}
