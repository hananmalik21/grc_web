import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class ManageEmployeesPageResult {
  final List<EmployeeListItem> items;
  final PaginationInfo pagination;

  const ManageEmployeesPageResult({required this.items, required this.pagination});
}
