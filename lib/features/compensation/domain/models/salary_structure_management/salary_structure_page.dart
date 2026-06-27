import 'salary_structure_item.dart';
import 'salary_structure_pagination.dart';

class SalaryStructurePage {
  final List<SalaryStructureItem> items;
  final SalaryStructurePagination? pagination;

  const SalaryStructurePage({required this.items, required this.pagination});
}
