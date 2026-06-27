import 'employee_list_item.dart';
import 'employees_pagination.dart';

class EmployeesPage {
  final List<EmployeeListItem> items;
  final EmployeesPagination? pagination;

  const EmployeesPage({required this.items, required this.pagination});
}
