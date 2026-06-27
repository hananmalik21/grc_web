import 'compensation_plan.dart';
import 'compensation_plans_pagination.dart';

class CompensationPlansPage {
  final List<CompensationPlan> items;
  final CompensationPlansPagination? pagination;

  const CompensationPlansPage({required this.items, required this.pagination});
}
