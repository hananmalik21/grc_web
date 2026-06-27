import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';

/// Local data source for forfeit policies
abstract class ForfeitPolicyLocalDataSource {
  List<ForfeitPolicy> getForfeitPolicies();
}

class ForfeitPolicyLocalDataSourceImpl implements ForfeitPolicyLocalDataSource {
  @override
  List<ForfeitPolicy> getForfeitPolicies() {
    return const [
      ForfeitPolicy(
        id: '1',
        name: 'Annual Leave',
        nameArabic: 'الإجازة السنوية',
        tags: ['30 Days', 'Per Year'],
        isActive: true,
        isSelected: true,
      ),
      ForfeitPolicy(
        id: '2',
        name: 'Sick Leave',
        nameArabic: 'إجازة مرضية',
        tags: ['15 Days', 'Per Year'],
        isActive: true,
      ),
      ForfeitPolicy(id: '3', name: 'Hajj Leave', nameArabic: 'إجازة الحج', tags: ['15 Days'], isActive: true),
      ForfeitPolicy(id: '4', name: 'Maternity Leave', nameArabic: 'إجازة الأمومة', tags: ['70 Days'], isActive: true),
      ForfeitPolicy(id: '5', name: 'Paternity Leave', nameArabic: 'إجازة الأبوة', tags: ['3 Days'], isActive: true),
      ForfeitPolicy(id: '6', name: 'Emergency Leave', nameArabic: 'إجازة طارئة', tags: ['5 Days'], isActive: true),
      ForfeitPolicy(id: '7', name: 'Study Leave', nameArabic: 'إجازة دراسية', tags: ['10 Days'], isActive: true),
      ForfeitPolicy(id: '8', name: 'Unpaid Leave', nameArabic: 'إجازة بدون راتب', tags: ['Unlimited'], isActive: true),
      ForfeitPolicy(id: '9', name: 'Compassionate Leave', nameArabic: 'إجازة تعزية', tags: ['3 Days'], isActive: true),
      ForfeitPolicy(id: '10', name: 'Marriage Leave', nameArabic: 'إجازة زواج', tags: ['3 Days'], isActive: true),
    ];
  }
}
