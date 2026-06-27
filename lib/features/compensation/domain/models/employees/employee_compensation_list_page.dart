import 'employee_compensation_list_item.dart';

class EmployeeCompensationListPage {
  const EmployeeCompensationListPage({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<EmployeeCompensationListItem> items;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
