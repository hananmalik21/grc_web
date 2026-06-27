import 'package:grc/features/security_manager/presentation/providers/data_classification/data_classification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataClassificationNotifier extends StateNotifier<DataClassificationState> {
  DataClassificationNotifier() : super(const DataClassificationState()) {
    state = state.copyWith(levels: _mockLevels);
  }

  static final _mockLevels = <DataClassificationLevel>[
    const DataClassificationLevel(
      type: DataClassificationType.public,
      protectedFields: ['Employee Name', 'Department', 'Job Title'],
      accessRoles: ['All Users'],
    ),
    const DataClassificationLevel(
      type: DataClassificationType.confidential,
      protectedFields: ['Salary', 'Performance Reviews', 'Leave Balance'],
      accessRoles: ['HR Manager', 'Payroll'],
    ),
    const DataClassificationLevel(
      type: DataClassificationType.restricted,
      protectedFields: ['Civil ID', 'Bank Details', 'SSN'],
      accessRoles: ['HR Director', 'Payroll Manager', 'CEO'],
    ),
  ];

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }

  List<DataClassificationLevel> get filteredLevels {
    final query = state.query.trim().toLowerCase();
    if (query.isEmpty) return state.levels;
    return state.levels.where((level) {
      final haystack = [
        level.type.label,
        level.type.subtitle,
        ...level.protectedFields,
        ...level.accessRoles,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  int get publicCount => state.levels.where((l) => l.type == DataClassificationType.public).length;
  int get confidentialCount => state.levels.where((l) => l.type == DataClassificationType.confidential).length;
  int get restrictedCount => state.levels.where((l) => l.type == DataClassificationType.restricted).length;
}

final dataClassificationProvider = StateNotifierProvider<DataClassificationNotifier, DataClassificationState>(
  (ref) => DataClassificationNotifier(),
);
