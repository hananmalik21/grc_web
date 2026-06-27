import 'package:grc/features/leave_management/domain/models/policy_history.dart';

/// Local data source for policy history
abstract class PolicyHistoryLocalDataSource {
  List<PolicyHistory> getPolicyHistory(String policyName);
}

class PolicyHistoryLocalDataSourceImpl implements PolicyHistoryLocalDataSource {
  @override
  List<PolicyHistory> getPolicyHistory(String policyName) {
    // Mock data - in a real app, this would come from a database or API
    return [
      const PolicyHistory(
        version: '2.1',
        date: '2024-01-15',
        author: 'HR Admin',
        description: 'Updated carry forward limit from 8 to 10 days, added pro-rata calculation',
      ),
      const PolicyHistory(
        version: '2.0',
        date: '2023-12-01',
        author: 'HR Admin',
        description: 'Enabled encashment with 15 day limit, added eligibility criteria',
      ),
      const PolicyHistory(
        version: '1.0',
        date: '2023-06-01',
        author: 'System',
        description: 'Initial policy creation with Kuwait Labor Law compliance',
      ),
    ];
  }
}
