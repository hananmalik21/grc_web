import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';

class PaginatedEmployees {
  final List<Employee> employees;
  final PaginationInfo pagination;
  final int total;
  final int count;

  const PaginatedEmployees({
    required this.employees,
    required this.pagination,
    required this.total,
    required this.count,
  });
}
