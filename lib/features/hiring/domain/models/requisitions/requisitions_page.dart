import 'requisition.dart';
import 'requisitions_pagination.dart';

class RequisitionsPage {
  const RequisitionsPage({required this.items, required this.pagination});

  final List<Requisition> items;
  final RequisitionsPagination? pagination;

  static const empty = RequisitionsPage(items: [], pagination: null);
}
