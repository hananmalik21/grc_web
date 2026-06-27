import 'package:grc/features/payroll/domain/models/element_entry_row.dart';

class ElementEntriesUiState {
  const ElementEntriesUiState({
    required this.entries,
    required this.selectedIndices,
    required this.effectiveDate,
    this.sortColumn,
    this.sortAscending = true,
  });

  final List<ElementEntryRow> entries;
  final Set<int> selectedIndices;
  final DateTime effectiveDate;
  final String? sortColumn;
  final bool sortAscending;

  bool get isAllSelected => entries.isNotEmpty && selectedIndices.length == entries.length;

  bool get hasSelection => selectedIndices.isNotEmpty;

  int get selectedCount => selectedIndices.length;

  factory ElementEntriesUiState.initial() {
    return ElementEntriesUiState(
      entries: List<ElementEntryRow>.from(kMockElementEntries),
      selectedIndices: {},
      effectiveDate: DateTime(2026, 6, 5),
    );
  }

  ElementEntriesUiState copyWith({
    List<ElementEntryRow>? entries,
    Set<int>? selectedIndices,
    DateTime? effectiveDate,
    String? sortColumn,
    bool? sortAscending,
    bool clearSortColumn = false,
  }) {
    return ElementEntriesUiState(
      entries: entries ?? this.entries,
      selectedIndices: selectedIndices ?? this.selectedIndices,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      sortColumn: clearSortColumn ? null : (sortColumn ?? this.sortColumn),
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }
}
