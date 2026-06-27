import '../models/employee_compensation_table_row_data.dart';
import '../widgets/employee_compensation/employee_compensation_config.dart';

class EmployeeCompensationState {
  final List<EmployeeCompensationTableRowData> allRows;
  final String searchQuery;
  final String selectedDepartment;
  final String selectedRegion;
  final int currentPage;

  const EmployeeCompensationState({
    required this.allRows,
    this.searchQuery = '',
    this.selectedDepartment = EmployeeCompensationConfig.allFilter,
    this.selectedRegion = EmployeeCompensationConfig.allFilter,
    this.currentPage = 1,
  });

  EmployeeCompensationState copyWith({
    List<EmployeeCompensationTableRowData>? allRows,
    String? searchQuery,
    String? selectedDepartment,
    String? selectedRegion,
    int? currentPage,
  }) {
    return EmployeeCompensationState(
      allRows: allRows ?? this.allRows,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDepartment: selectedDepartment ?? this.selectedDepartment,
      selectedRegion: selectedRegion ?? this.selectedRegion,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  List<EmployeeCompensationTableRowData> get filteredRows {
    return allRows.where((row) {
      final matchesSearch = row.matchesSearch(searchQuery);
      final matchesDepartment =
          selectedDepartment == EmployeeCompensationConfig.allFilter || row.department == selectedDepartment;
      final matchesRegion = selectedRegion == EmployeeCompensationConfig.allFilter || row.region == selectedRegion;

      return matchesSearch && matchesDepartment && matchesRegion;
    }).toList();
  }

  int get totalPages {
    final filtered = filteredRows;
    if (filtered.isEmpty) return 1;
    return (filtered.length / EmployeeCompensationConfig.pageSize).ceil();
  }

  int get safeCurrentPage {
    final total = totalPages;
    return currentPage > total ? total : currentPage;
  }

  List<EmployeeCompensationTableRowData> get visibleRows {
    final filtered = filteredRows;
    final safePage = safeCurrentPage;
    final startIndex = (safePage - 1) * EmployeeCompensationConfig.pageSize;
    final endIndex = ((startIndex + EmployeeCompensationConfig.pageSize).clamp(0, filtered.length) as num).toInt();
    return filtered.sublist(startIndex, endIndex);
  }

  List<String> get departmentOptions {
    return <String>{EmployeeCompensationConfig.allFilter, ...allRows.map((row) => row.department)}.toList();
  }

  List<String> get regionOptions {
    return <String>{EmployeeCompensationConfig.allFilter, ...allRows.map((row) => row.region)}.toList();
  }
}
