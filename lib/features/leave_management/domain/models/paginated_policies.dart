import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class PaginatedPolicies {
  final List<PolicyListItem> policies;
  final PaginationInfo pagination;

  const PaginatedPolicies({required this.policies, required this.pagination});

  static PaginatedPolicies get empty => PaginatedPolicies(
    policies: const [],
    pagination: PaginationInfo(
      currentPage: 1,
      totalPages: 1,
      totalItems: 0,
      pageSize: 10,
      hasNext: false,
      hasPrevious: false,
    ),
  );
}
