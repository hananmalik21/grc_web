import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_entry.dart';
import 'package:grc/features/compensation/domain/models/employees/employees_pagination.dart';

class BulkEmployeeComponentsPage {
  const BulkEmployeeComponentsPage({required this.count, required this.employees, required this.pagination});

  final int count;
  final List<BulkEmployeeComponentsEntry> employees;
  final EmployeesPagination pagination;

  static const empty = BulkEmployeeComponentsPage(
    count: 0,
    employees: [],
    pagination: EmployeesPagination(page: 1, pageSize: 10, total: 0, totalPages: 1, hasNext: false, hasPrevious: false),
  );
}
