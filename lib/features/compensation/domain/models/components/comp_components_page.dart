import 'comp_component.dart';
import 'comp_components_pagination.dart';

class CompComponentsPage {
  final List<CompComponent> items;
  final CompComponentsPagination? pagination;

  const CompComponentsPage({required this.items, required this.pagination});
}
