import 'package:grc/features/payroll/application/element_entries/states/element_entries_ui_state.dart';
import 'package:grc/features/payroll/domain/models/element_entry_row.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ElementEntriesUiController extends StateNotifier<ElementEntriesUiState> {
  ElementEntriesUiController() : super(ElementEntriesUiState.initial());

  void setEffectiveDate(DateTime date) {
    state = state.copyWith(effectiveDate: date);
  }

  void toggleSelection(int index, bool selected) {
    final next = Set<int>.from(state.selectedIndices);
    if (selected) {
      next.add(index);
    } else {
      next.remove(index);
    }
    state = state.copyWith(selectedIndices: next);
  }

  void setSelectAll(bool selected) {
    if (!selected || state.entries.isEmpty) {
      state = state.copyWith(selectedIndices: {});
      return;
    }
    state = state.copyWith(selectedIndices: Set<int>.from(List.generate(state.entries.length, (index) => index)));
  }

  void sort(String columnKey) {
    final ascending = state.sortColumn == columnKey ? !state.sortAscending : true;
    final sorted = List<ElementEntryRow>.from(state.entries);

    sorted.sort((a, b) {
      dynamic valA;
      dynamic valB;

      switch (columnKey) {
        case 'elementName':
          valA = a.elementName;
          valB = b.elementName;
        case 'primaryEntryValue':
          valA = a.primaryEntryValue;
          valB = b.primaryEntryValue;
        case 'valueName':
          valA = a.valueName;
          valB = b.valueName;
        case 'source':
          valA = a.source;
          valB = b.source;
        case 'employmentLevel':
          valA = a.employmentLevel;
          valB = b.employmentLevel;
        case 'reason':
          valA = a.reason;
          valB = b.reason;
        case 'classification':
          valA = a.classification;
          valB = b.classification;
        case 'ldg':
          valA = a.ldg;
          valB = b.ldg;
        case 'empNumber':
          valA = a.empNumber;
          valB = b.empNumber;
        case 'status':
          valA = a.status;
          valB = b.status;
        default:
          return 0;
      }

      if (!ascending) {
        final temp = valA;
        valA = valB;
        valB = temp;
      }

      if (valA is num && valB is num) {
        return valA.compareTo(valB);
      }
      return valA.toString().compareTo(valB.toString());
    });

    state = state.copyWith(entries: sorted, sortColumn: columnKey, sortAscending: ascending);
  }

  void deleteSelected() {
    if (state.selectedIndices.isEmpty) return;

    final indicesToRemove = state.selectedIndices.toList()..sort((a, b) => b.compareTo(a));
    final nextEntries = List<ElementEntryRow>.from(state.entries);

    for (final index in indicesToRemove) {
      if (index >= 0 && index < nextEntries.length) {
        nextEntries.removeAt(index);
      }
    }

    state = state.copyWith(entries: nextEntries, selectedIndices: {});
  }

  void reset() {
    state = ElementEntriesUiState(
      entries: List<ElementEntryRow>.from(kMockElementEntries),
      selectedIndices: {},
      effectiveDate: state.effectiveDate,
    );
  }
}
