import 'package:grc/features/leave_management/domain/models/paginated_policies.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_item.dart';

abstract class AbsPoliciesRepository {
  Future<PaginatedPolicies> getPolicies({required int tenantId, int page = 1, int pageSize = 10});
  Future<PolicyListItem?> createPolicy(dynamic createRequest);
  Future<PolicyListItem?> updatePolicy(String policyGuid, dynamic updateRequest);
}
