import 'package:grc/features/leave_management/domain/models/leave_type.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';

/// Local data source for policy configuration
abstract class PolicyConfigurationLocalDataSource {
  List<LeaveType> getLeaveTypes();
  PolicyConfiguration? getPolicyConfiguration(String policyName);
  List<PolicyConfiguration> getAllPolicyConfigurations();
}

class PolicyConfigurationLocalDataSourceImpl implements PolicyConfigurationLocalDataSource {
  @override
  List<LeaveType> getLeaveTypes() {
    return const [
      LeaveType(
        name: 'Annual Leave',
        nameArabic: 'الإجازة السنوية',
        tags: ['30 Days', 'Per Year'],
        isActive: true,
        isSelected: true,
      ),
      LeaveType(name: 'Sick Leave', nameArabic: 'إجازة مرضية', tags: ['15 Days', 'Per Year'], isActive: true),
      LeaveType(name: 'Hajj Leave', nameArabic: 'إجازة الحج', tags: ['15 Days'], isActive: true),
      LeaveType(name: 'Maternity Leave', nameArabic: 'إجازة الأمومة', tags: ['70 Days'], isActive: true),
      LeaveType(name: 'Paternity Leave', nameArabic: 'إجازة الأبوة', tags: ['3 Days'], isActive: true),
      LeaveType(name: 'Emergency Leave', nameArabic: 'إجازة طارئة', tags: ['5 Days'], isActive: true),
      LeaveType(name: 'Study Leave', nameArabic: 'إجازة دراسية', tags: ['10 Days'], isActive: true),
      LeaveType(name: 'Unpaid Leave', nameArabic: 'إجازة بدون راتب', tags: ['Unlimited'], isActive: true),
      LeaveType(name: 'Compassionate Leave', nameArabic: 'إجازة تعزية', tags: ['3 Days'], isActive: true),
      LeaveType(name: 'Marriage Leave', nameArabic: 'إجازة زواج', tags: ['3 Days'], isActive: true),
    ];
  }

  @override
  PolicyConfiguration? getPolicyConfiguration(String policyName) {
    final allConfigs = getAllPolicyConfigurations();
    try {
      return allConfigs.firstWhere((config) => config.policyName == policyName);
    } catch (e) {
      return null;
    }
  }

  PolicyConfiguration _createDefaultPolicyConfiguration({
    required String policyName,
    required String policyNameArabic,
    required String version,
    required String annualEntitlement,
    required List<String> tags,
  }) {
    return PolicyConfiguration(
      policyName: policyName,
      leaveTypeName: 'Annual Leave',
      leaveTypeNameArabic: 'إجازة سنوية',
      version: '1.2.0',
      lastModified: '2024-01-15',
      selectedBy: 'HR Admin',
      tags: tags,
      isActive: true,
      eligibilityCriteria: const EligibilityCriteria(
        yearsOfServiceEnabled: false,
        minYearsRequired: '1',
        maxYearsAllowed: 'No limit',
        employeeCategoryEnabled: false,
        employmentTypeEnabled: false,
        contractTypeEnabled: false,
        genderEnabled: false,
        religionEnabled: false,
        maritalStatusEnabled: false,
        availableDuringProbation: false,
      ),
      entitlementAccrual: EntitlementAccrual(
        annualEntitlement: annualEntitlement,
        accrualMethod: 'Monthly',
        accrualRate: '2.5',
        effectiveDate: '01/01/2024',
        enableProRataCalculation: false,
      ),
      advancedRules: const AdvancedRules(
        maxConsecutiveDays: '10',
        minNoticePeriod: '14',
        countWeekendsAsLeave: false,
        countPublicHolidaysAsLeave: false,
        requiredSupportingDocumentation: false,
      ),
      approvalWorkflows: const ApprovalWorkflows(approvalWorkflow: 'Manager', autoApprovalThreshold: '0'),
      blackoutPeriods: const BlackoutPeriods(fromTo: '01/01/2024 - 31/12/2024'),
      carryForwardRules: const CarryForwardRules(allowCarryForward: false, carryForwardLimit: '10', gracePeriod: '90'),
      forfeitRules: const ForfeitRules(enableAutomaticForfeit: false, endOfGracePeriod: '28 days before'),
      encashmentRules: const EncashmentRules(allowLeaveEncashment: false, encashmentLimit: '15', encashmentRate: '100'),
      complianceCheck: const ComplianceCheck(
        minimumEntitlementMet: true,
        accrualMethodValid: true,
        eligibilityCriteriaValid: true,
      ),
    );
  }

  @override
  List<PolicyConfiguration> getAllPolicyConfigurations() {
    return [
      _createDefaultPolicyConfiguration(
        policyName: 'Annual Leave',
        policyNameArabic: 'الإجازة السنوية',
        version: '2.1',
        annualEntitlement: '30',
        tags: const ['30 Days', 'Per Year'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Sick Leave',
        policyNameArabic: 'إجازة مرضية',
        version: '1.0',
        annualEntitlement: '15',
        tags: const ['15 Days', 'Per Year'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Hajj Leave',
        policyNameArabic: 'إجازة الحج',
        version: '1.0',
        annualEntitlement: '15',
        tags: const ['15 Days'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Maternity Leave',
        policyNameArabic: 'إجازة الأمومة',
        version: '1.0',
        annualEntitlement: '70',
        tags: const ['70 Days'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Paternity Leave',
        policyNameArabic: 'إجازة الأبوة',
        version: '1.0',
        annualEntitlement: '3',
        tags: const ['3 Days'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Emergency Leave',
        policyNameArabic: 'إجازة طارئة',
        version: '1.0',
        annualEntitlement: '5',
        tags: const ['5 Days'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Study Leave',
        policyNameArabic: 'إجازة دراسية',
        version: '1.0',
        annualEntitlement: '10',
        tags: const ['10 Days'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Unpaid Leave',
        policyNameArabic: 'إجازة بدون راتب',
        version: '1.0',
        annualEntitlement: 'Unlimited',
        tags: const ['Unlimited'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Compassionate Leave',
        policyNameArabic: 'إجازة تعزية',
        version: '1.0',
        annualEntitlement: '3',
        tags: const ['3 Days'],
      ),
      _createDefaultPolicyConfiguration(
        policyName: 'Marriage Leave',
        policyNameArabic: 'إجازة زواج',
        version: '1.0',
        annualEntitlement: '3',
        tags: const ['3 Days'],
      ),
    ];
  }
}
