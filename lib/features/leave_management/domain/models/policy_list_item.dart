import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/domain/models/policy_list_enums.dart';

/// Lightweight policy item for the policy configuration list (e.g. leave types list).
/// Maps from GET /api/abs/policies response.
class PolicyListItem {
  final int policyId;
  final String policyGuid;
  final String name;
  final String nameArabic;
  final List<String> tags;
  final bool isActive;
  final PolicyStatus status;
  final int entitlementDays;
  final PolicyAccrualMethod accrualMethod;
  final String? policyName;

  /// Full policy detail for displaying configuration sections
  final PolicyDetail? detail;

  const PolicyListItem({
    required this.policyId,
    required this.policyGuid,
    required this.name,
    required this.nameArabic,
    required this.tags,
    required this.isActive,
    required this.status,
    required this.entitlementDays,
    required this.accrualMethod,
    this.policyName,
    this.detail,
  });
}
