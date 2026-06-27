import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class BulkSelectedAdjustmentRow {
  const BulkSelectedAdjustmentRow({
    required this.adjustmentId,
    required this.employeeGuid,
    required this.employeeName,
    required this.employeeNumericId,
  });

  final String adjustmentId;
  final String employeeGuid;
  final String employeeName;
  final int employeeNumericId;

  factory BulkSelectedAdjustmentRow.from(AdjustmentRowData row) {
    return BulkSelectedAdjustmentRow(
      adjustmentId: row.adjustmentId,
      employeeGuid: row.employeeGuid,
      employeeName: row.employeeName,
      employeeNumericId: row.employeeNumericId,
    );
  }
}

@immutable
class BulkAdjustmentsTableSelection {
  const BulkAdjustmentsTableSelection([this.entries = const {}]);

  final Map<String, BulkSelectedAdjustmentRow> entries;

  bool get isEmpty => entries.isEmpty;

  bool get isNotEmpty => entries.isNotEmpty;

  bool contains(String adjustmentId) => entries.containsKey(adjustmentId);
}

final bulkAdjustmentsTableSelectionProvider =
    StateNotifierProvider<BulkAdjustmentsTableSelectionNotifier, BulkAdjustmentsTableSelection>(
      (ref) => BulkAdjustmentsTableSelectionNotifier(),
    );

class BulkAdjustmentsTableSelectionNotifier extends StateNotifier<BulkAdjustmentsTableSelection> {
  BulkAdjustmentsTableSelectionNotifier() : super(const BulkAdjustmentsTableSelection());

  bool isSelected(String adjustmentId) => state.contains(adjustmentId);

  void toggle(AdjustmentRowData row) {
    final entries = Map<String, BulkSelectedAdjustmentRow>.from(state.entries);
    if (entries.containsKey(row.adjustmentId)) {
      entries.remove(row.adjustmentId);
    } else {
      entries[row.adjustmentId] = BulkSelectedAdjustmentRow.from(row);
    }
    state = BulkAdjustmentsTableSelection(entries);
  }

  void clear() => state = const BulkAdjustmentsTableSelection();

  bool areAllSelected(List<AdjustmentRowData> rows) {
    if (rows.isEmpty) return false;
    return rows.every((row) => state.contains(row.adjustmentId));
  }

  void toggleAll(List<AdjustmentRowData> rows) {
    if (areAllSelected(rows)) {
      setAllForRows(rows, selected: false);
    } else {
      setAllForRows(rows, selected: true);
    }
  }

  void setAllForRows(List<AdjustmentRowData> rows, {required bool selected}) {
    final entries = Map<String, BulkSelectedAdjustmentRow>.from(state.entries);
    for (final row in rows) {
      if (selected) {
        entries[row.adjustmentId] = BulkSelectedAdjustmentRow.from(row);
      } else {
        entries.remove(row.adjustmentId);
      }
    }
    state = BulkAdjustmentsTableSelection(entries);
  }
}
