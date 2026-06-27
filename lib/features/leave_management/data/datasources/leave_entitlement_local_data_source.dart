import 'package:grc/features/leave_management/domain/models/leave_entitlement.dart';

/// Local data source for Kuwait Labor Law leave entitlements
/// This data is static and based on Kuwait Labor Law regulations
abstract class LeaveEntitlementLocalDataSource {
  List<LeaveEntitlement> getKuwaitLawEntitlements();
}

class LeaveEntitlementLocalDataSourceImpl implements LeaveEntitlementLocalDataSource {
  @override
  List<LeaveEntitlement> getKuwaitLawEntitlements() {
    return const [
      LeaveEntitlement(
        id: 'annual_leave',
        titleKey: 'annualLeave',
        entitlementKey: 'annualLeaveEntitlement',
        backgroundColorKey: 'infoBg',
        titleColorKey: 'infoText',
        subtitleColorKey: 'infoTextSecondary',
      ),
      LeaveEntitlement(
        id: 'sick_leave',
        titleKey: 'sickLeave',
        entitlementKey: 'sickLeaveEntitlement',
        backgroundColorKey: 'greenBg',
        titleColorKey: 'greenText',
        subtitleColorKey: 'activeStatusTextLight',
      ),
      LeaveEntitlement(
        id: 'maternity_leave',
        titleKey: 'maternityLeave',
        entitlementKey: 'maternityLeaveEntitlement',
        backgroundColorKey: 'pinkBackground',
        titleColorKey: 'pinkTitleText',
        subtitleColorKey: 'pinkSubtitle',
      ),
      LeaveEntitlement(
        id: 'emergency_leave',
        titleKey: 'emergencyLeave',
        entitlementKey: 'emergencyLeaveEntitlement',
        backgroundColorKey: 'warningBg',
        titleColorKey: 'yellowText',
        subtitleColorKey: 'yellowSubtitle',
      ),
    ];
  }
}
