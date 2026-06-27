import 'package:grc/features/leave_management/domain/models/leave_policy.dart';

/// Local data source for leave policies
/// This data is static and based on Kuwait Labor Law regulations
abstract class LeavePoliciesLocalDataSource {
  List<LeavePolicy> getLeavePolicies();
}

class LeavePoliciesLocalDataSourceImpl implements LeavePoliciesLocalDataSource {
  @override
  List<LeavePolicy> getLeavePolicies() {
    return const [
      LeavePolicy(
        nameEn: 'Annual Leave',
        nameAr: 'إجازة سنوية',
        isKuwaitLaw: true,
        description: 'Standard annual leave per Kuwait Labor Law - 30 days after 1 year of service',
        entitlement: '30 days',
        accrualType: 'Monthly',
        minService: '12 months',
        advanceNotice: '7 days',
        isPaid: true,
        carryoverDays: 30,
        requiresAttachment: false,
        genderRestriction: null,
      ),
      LeavePolicy(
        nameEn: 'Sick Leave',
        nameAr: 'إجازة مرضية',
        isKuwaitLaw: true,
        description: 'Sick leave: 15 days full pay + 10 days half pay + 10 days unpaid',
        entitlement: '35 days',
        accrualType: 'Yearly',
        minService: '0 months',
        advanceNotice: '0 days',
        isPaid: true,
        carryoverDays: null,
        requiresAttachment: true,
        genderRestriction: null,
      ),
      LeavePolicy(
        nameEn: 'Maternity Leave',
        nameAr: 'إجازة أمومة',
        isKuwaitLaw: true,
        description: '70 days fully paid maternity leave (Kuwait Labor Law)',
        entitlement: '70 days',
        accrualType: 'None',
        minService: '12 months',
        advanceNotice: '30 days',
        isPaid: true,
        carryoverDays: null,
        requiresAttachment: true,
        genderRestriction: 'Female',
      ),
      LeavePolicy(
        nameEn: 'Paternity Leave',
        nameAr: 'إجازة أبوة',
        isKuwaitLaw: false,
        description: '3 days paid paternity leave',
        entitlement: '3 days',
        accrualType: 'None',
        minService: '0 months',
        advanceNotice: '7 days',
        isPaid: true,
        carryoverDays: null,
        requiresAttachment: true,
        genderRestriction: 'Male',
      ),
      LeavePolicy(
        nameEn: 'Hajj Leave',
        nameAr: 'إجازة حج',
        isKuwaitLaw: true,
        description: 'Pilgrimage leave - 21 days (once every 5 years, unpaid)',
        entitlement: '21 days',
        accrualType: 'None',
        minService: '60 months',
        advanceNotice: '60 days',
        isPaid: false,
        carryoverDays: null,
        requiresAttachment: true,
        genderRestriction: null,
      ),
      LeavePolicy(
        nameEn: 'Bereavement Leave',
        nameAr: 'إجازة وفاة',
        isKuwaitLaw: false,
        description: 'Bereavement leave for immediate family members',
        entitlement: '3 days',
        accrualType: 'None',
        minService: '0 months',
        advanceNotice: '0 days',
        isPaid: true,
        carryoverDays: null,
        requiresAttachment: true,
        genderRestriction: null,
      ),
    ];
  }
}
