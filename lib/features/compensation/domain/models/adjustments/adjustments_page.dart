import 'adjustment.dart';

class AdjustmentsPage {
  final List<Adjustment> adjustments;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const AdjustmentsPage({
    required this.adjustments,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
